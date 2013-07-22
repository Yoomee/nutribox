class Order < ActiveRecord::Base

Order::FREQUENCIES = %w{ weekly fortnightly monthly bi-monthly }

  include YmCore::Model
  include YmCore::Multistep
  include Xero::Order

  belongs_to :user
  has_many :deliveries, :dependent => :destroy
  belongs_to :theme, :class_name => 'AvailableOrderOption'
  has_many :repeat_payments
  amount_accessor :amount, :full_price_amount
  
  attr_accessor :login_email, :login_password
  boolean_accessor :editing_by_admin

  validates :theme_id, :presence => true, :if => :current_step_box?
  validates :frequency, :presence => true, :inclusion=> { :in => Order::FREQUENCIES }, :if => :current_step_frequency?
  validates :box_type, :number_of_deliveries_paid_for_each_billing, :presence => true, :if => :current_step_frequency?
  validates :user, :delivery_address1, :delivery_city, :delivery_postcode, :delivery_country,  :presence => true, :if => :current_step_delivery?
  #validates :delivery_postcode, :postcode => true, :if => :current_step_delivery?, :allow_blank => true
  validates :billing_address1, :billing_city, :billing_postcode, :billing_country,  :presence => true, :if => :current_step_billing?
  #validates :billing_postcode, :postcode => true, :if => :current_step_billing?, :allow_blank => true
  validate  :credit_card_is_valid, :if => :current_step_billing? 
  
  before_create :set_hash_id
  before_validation :set_amount
  before_validation :set_billing_name
  before_validation :set_shipping_week
  before_save :nullify_discount_code_code_if_invalid
  belongs_to :discount_code, :primary_key => :code, :foreign_key => :discount_code_code
  
  accepts_nested_attributes_for :user
  
  scope :active, where(:status => 'active')
  scope :alphabetical_by_user, joins(:user).order("users.last_name,users.first_name")
  scope :bi_monthly, where(:frequency => 'bi-monthly')
  scope :fortnightly, where(:frequency => 'fortnightly')
  scope :monthly, where(:frequency => 'monthly')
  scope :not_failed, where("status != 'failed'")
  scope :repeatable, active.where(:gift => false).where('number_of_deliveries_paid_for_each_billing <> 12').where('deliveries_count >= number_of_deliveries_paid_for')
  scope :weekly, where(:frequency => 'weekly')

  class << self
    def for_shipping_date_by_weeks(weeks)
      for_delivery_or_payment_by_weeks(weeks)
    end

    def for_delivery_or_payment_by_weeks(weeks, date=Date.today)
      fortnightly_orders_with_deliveries_in_last_ten_days = fortnightly.joins(:deliveries).where('deliveries.created_at > ?', date - 10.days)
      bi_monthly_orders_with_deliveries_in_last_thirty_five_days = bi_monthly.joins(:deliveries).where{(deliveries.created_at > date - 35.days) & (shipping_week.in(weeks))}

      where{
             (frequency == 'weekly') |
             ((frequency == 'fortnightly') & (id.not_in(fortnightly_orders_with_deliveries_in_last_ten_days.select{id}))) |
             ((frequency == 'monthly') & (shipping_week.in(weeks))) |
             ((frequency == 'bi-monthly') & (shipping_week.in(weeks)) & (id.not_in(bi_monthly_orders_with_deliveries_in_last_thirty_five_days.select{id})))
            }
    end

    def repeatable_by_week(date)
      date_for_correct_week = date - 1.day
      if date_for_correct_week.shipping_week == 4 && !date_for_correct_week.five_fridays_in_month?
        shipping_weeks = [4, 5]
      else
        shipping_weeks = date_for_correct_week.shipping_week
      end

      repeatable.for_delivery_or_payment_by_weeks(shipping_weeks, date)
    end

    def number_of_snacks(box_type)
      case box_type
      when "mini" then "8-10"
      when "standard"  then "16-20"
      else
        ""
      end
    end
    
    # def box_name(box_type)
    #   case box_type.to_s
    #   when "mini" then "The Nutribox Mini"
    #   when "standard" then "The Nutribox"
    #   end
    # end
  
    # def cost_in_pence(box_type,number_of_deliveries_paid_for_each_billing)
    #   return 0 unless box_type
    #   Order::COST_MATRIX[box_type.to_sym].try(:[], number_of_deliveries_paid_for_each_billing).to_i
    # end
  
    # def cost(box_type,number_of_deliveries_paid_for_each_billing)
    #   YmCore::Model::AmountAccessor::Float.new((self.cost_in_pence(box_type,number_of_deliveries_paid_for_each_billing).to_f / 100).round(2))
    # end

    # def cost_per_month(box_type,number_of_deliveries_paid_for_each_billing)
    #   YmCore::Model::AmountAccessor::Float.new(((self.cost_in_pence(box_type,number_of_deliveries_paid_for_each_billing).to_f / 100) / number_of_deliveries_paid_for_each_billing).round(2))
    # end

    def saving_in_pence(box_type,number_of_deliveries_paid_for_each_billing)
      (cost_in_pence(box_type,1) * number_of_deliveries_paid_for_each_billing) - cost_in_pence(box_type,number_of_deliveries_paid_for_each_billing)
    end
    
    def saving_percentage(box_type,number_of_deliveries_paid_for_each_billing)
      saving = ((saving_in_pence(box_type,number_of_deliveries_paid_for_each_billing).to_f / (cost_in_pence(box_type,1) * number_of_deliveries_paid_for_each_billing)) * 100)
      saving = saving + 0.1 # Hack so that 3 month Nutribox-mini discount is rounded from 9.91% to 10%
      saving.to_i
    end
    
    def statuses
      ["active","failed","paused","cancelled", "ended"]
    end

  end
  
  def amount_ex_vat
    unrounded = amount.to_f * ((100 - Order::VAT_PERCENTAGES[box_type.to_sym]) / 100.to_f)
    # Round down for tax purposes
    (unrounded * 100).floor / 100.0
  end
  
  def vat
    (amount - amount_ex_vat).round(2)
  end
  
  def set_billing_address_from_delivery_address
    if billing_address1.blank?
      self.billing_address1 = delivery_address1
      self.billing_address2 = delivery_address2
      self.billing_city = delivery_city
      self.billing_postcode = delivery_postcode
      self.billing_country = delivery_country
    end
  end
  
  def box_name
    "#{theme} #{ box_type == 'mini' ? 'Mini' : '' }"
  end

  def box_name_from_size(size)
    "#{theme} #{ size == 'mini' ? 'Mini' : '' }"
  end

  # def box_name_with_options
  #   if options.present?
  #     box_name + " (#{options.join(', ')})"
  #   else
  #     box_name
  #   end
  # end

  def box_type_and_number_of_deliveries_paid_for_each_billing
    [box_type,number_of_deliveries_paid_for_each_billing].compact.join('-')
  end
  
  def box_type_and_number_of_deliveries_paid_for_each_billing=(value)
    self.box_type, self.number_of_deliveries_paid_for_each_billing = value.split('-')
    self.full_price_amount_in_pence = theme.cost_in_pence(box_type, number_of_deliveries_paid_for_each_billing)
  end
  
  # def cost(box_type, number_of_deliveries_paid_for_each_billing)
  #   if discount_code.try(:available?)
  #     YmCore::Model::AmountAccessor::Float.new(((Order.cost_in_pence(box_type,number_of_deliveries_paid_for_each_billing) - (discount_code.fraction * Order.cost_in_pence(box_type,1)).ceil) / 100.to_f).round(2))
  #   else
  #     Order.cost(box_type,number_of_deliveries_paid_for_each_billing)
  #   end
  # end

  # def cost_per_month(box_type, number_of_deliveries_paid_for_each_billing)
  #   if discount_code.try(:available?)
  #     YmCore::Model::AmountAccessor::Float.new((((Order.cost_in_pence(box_type,number_of_deliveries_paid_for_each_billing) - (discount_code.fraction * Order.cost_in_pence(box_type,1)).ceil) / 100.to_f) / number_of_deliveries_paid_for_each_billing).round(2))
  #   else
  #     Order.cost_per_month(box_type,number_of_deliveries_paid_for_each_billing)
  #   end
  # end

  def cost
    return 0 unless theme.present? && box_type.present? && number_of_deliveries_paid_for_each_billing.present?
    theme.cost(box_type, number_of_deliveries_paid_for_each_billing)
  end

  def cost_by_number_of_deliveries(number_of_deliveries)
    return 0 unless theme.present? && box_type.present?
    theme.cost(box_type, number_of_deliveries)
  end

  def credit_card  
    @credit_card ||= ActiveMerchant::Billing::CreditCard.new  
  end    
  
  def credit_card_attributes  
    credit_card.attributes  
  end
    
  def credit_card_attributes=(attrs)  
    attrs.reject!{|a| a.blank?}  
    @credit_card = ActiveMerchant::Billing::CreditCard.new(attrs)  
  end
  
  def delivery_address(separator = ', ')
    [delivery_name,delivery_address1,delivery_address2,delivery_city,delivery_postcode].select(&:present?).join(separator)
  end
  
  def discount
    discount_in_pence.zero? ? nil : (discount_in_pence / 100.to_f)
  end
  
  def discount_in_pence
    return 0 unless box_type.present? && theme.present? && discount_code.try(:available_to?,user)
    (discount_code.fraction * theme.cost_in_pence(box_type, 1)).ceil
  end
  
  def discounted?
    amount < full_price_amount
  end
  
  def billing_country
    "GB"
  end  
  
  def delivery_country
    "GB"
  end  

  def first_shipping_date
    next_shipping_date((created_at.presence || Time.now).to_date)
  end

  def next_delivery_date
    next_shipping_date + 5.days
  end
  
  def next_shipping_date(date = Date.today)
    # Next friday
    date += 7.days if date.wday == 5
    date + (5 - date.wday) % 7
  end
  
  def order_number
    # hack to fix repeat payments for order 214, as it uses transaction details copied from order 3
    return "NB3" if Rails.env.production? && id == 214
    Rails.env.development? ? "dev#{id}" : "NB#{id}"
  end
  
  def product
    "#{box_name} delivered #{frequency} #{gift? ? '- a gift' : ''}"
  end

  def repeatable?
    !gift? && (number_of_deliveries_paid_for_each_billing == 1 || ([3 ,6].include?(number_of_deliveries_paid_for_each_billing) && (new_record? || created_at > Time.parse('11/04/2013'))))
  end

  def sage_pay_id
    vps_transaction_id.to_s.gsub(/[{}]/,'').presence
  end

  def status_class(prefix = "")
    prefix + case status
    when "active" then "success"
    when "failed" then "important"
    when "paused" then "warning"
    else
      "default"
    end
  end
  
  def sku
    "NB".tap do |str|
      str << box_type[0].upcase
      str << number_of_deliveries_paid_for_each_billing.to_s
      str << "G" if gift?
    end
  end
  
  def failed?
    [vps_transaction_id,security_key,transaction_auth_number].any?(:blank?)
  end
  
  def recurring?
    number_of_deliveries_paid_for_each_billing != 12 && !gift?
  end
  
  def successful?
    !failed?
  end
  
  def steps
    %w{box frequency register delivery billing confirm}
  end
  
  def take_payment!
    if credit_card.valid?
      sage_pay_response = gateway.purchase(
      amount_in_pence,
      credit_card,
      :order_id => order_number,
      :billing_address => {
        :name => billing_name,
        :address1 => billing_address1,
        :address2 => billing_address2,
        :city => billing_city,
        :zip => billing_postcode,
        :country => billing_country
      }
      )
      process_response(sage_pay_response,self)
    end
  end
  
  def take_repeat_payment!
    repeat = self.repeat_payments.build(:amount_in_pence => full_price_amount_in_pence)
    if repeat.save # ID is needed for SagePay
      related = attributes.symbolize_keys.slice(:id,:vps_transaction_id,:security_key,:transaction_auth_number)
      related[:id] = order_number
      sage_pay_response = gateway.repeat(
        full_price_amount_in_pence,
        :order_id => repeat.order_number,
        :related_transaction => related
      )
      begin
        process_response(sage_pay_response,repeat)
      rescue Order::PaymentError => e
        logger.info e
        repeat.errors.add(:vps_transaction_id, e.message)
      end
    end
    repeat
  end
  
  def set_test_card_details  
    self.credit_card_attributes = {  
      :name => user.try(:full_name),  
      :number => "4929000000006",  
      :month => "10",  
      :year => "2017",  
      :verification_value => "123"  
    }  
  end  

  def warn_if_changing_status?
    return false if gift? && number_of_deliveries_paid_for_each_billing == 1
    (shipping_day - 10 <= Date.today.day) && (Date.today.day <= shipping_day)
  end

  def xero_order_number
    Rails.env.development? ? "dev#{id}" : "NB-#{id}"
  end

  def set_hash_id
    begin
      uniq_hash = "NB#{(100..999).to_a.sample.to_s}#{id}"
    end while Order.exists?(:hash_id => uniq_hash)
    self.hash_id = uniq_hash  
  end

  def to_param
    hash_id
  end
  
  class PaymentError < StandardError; end
  
  private
  def credit_card_is_valid  
    if !credit_card.valid?  
      errors.add(:credit_card, "card details are invalid")  
    end  
    [*credit_card.errors.on(:last_name)].each do |message|  
      message = "can't be blank" if message == "cannot be empty"  
      credit_card.errors.add(:name, message)  
    end  
  end  
  
  
  def gateway
    @gateway ||= begin
      if false #simulate
        gwy = ActiveMerchant::Billing::SagePayGateway.new(:login => "yoomeedeveloper")
        gwy.simulate = true
      else
        gwy = ActiveMerchant::Billing::SagePayGateway.new(:login => Settings.sage_pay_vendor_name)
      end
      gwy
    end
  end
  
  def process_response(sage_pay_response,transaction)
    logger.info sage_pay_response.inspect
    if sage_pay_response.success?
      transaction_attributes = {
      :vps_transaction_id => sage_pay_response.params["VPSTxId"],
      :security_key => sage_pay_response.params["SecurityKey"],
      :transaction_auth_number => sage_pay_response.params["TxAuthNo"]
      }
      order = transaction.is_a?(Order) ? transaction : transaction.order
      new_number_of_deliveries_paid_for = (order.number_of_deliveries_paid_for.to_i + order.number_of_deliveries_paid_for_each_billing)
      if transaction.is_a?(Order)
        transaction_attributes[:number_of_deliveries_paid_for] = new_number_of_deliveries_paid_for
      else
        order.update_attributes(:number_of_deliveries_paid_for => new_number_of_deliveries_paid_for)
      end
      transaction.update_attributes(transaction_attributes)
    else
      raise Order::PaymentError, sage_pay_response.message
    end
  end
  
  def set_billing_name
    self.billing_name = credit_card.name
  end
  
  def set_amount
    # Only change amount if it hasn't been charged
    if vps_transaction_id.blank? && full_price_amount_in_pence.present?
      self.amount_in_pence = full_price_amount_in_pence - discount_in_pence.to_i
    end
  end

  def set_shipping_week
    return true if shipping_week.present?
    order_date = (created_at || Time.now)
    self.shipping_week = order_date.to_date.shipping_week
  end

  def nullify_discount_code_code_if_invalid
    if discount_code_code.present? && !discounted?
      self.discount_code_code = nil
    end
  end  
end


Order::VAT_PERCENTAGES = {
  :mini => 11.28,
  :standard => 8.29
}