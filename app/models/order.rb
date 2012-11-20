class Order < ActiveRecord::Base
  include YmCore::Model
  include YmCore::Multistep
    
  belongs_to :user  
  amount_accessor
  
  attr_accessor :login_email, :login_password

  validates :box_type, :number_of_months, :presence => true, :if => :current_step_box?
  validates :user, :delivery_address1, :delivery_city, :delivery_postcode, :delivery_country,  :presence => true, :if => :current_step_delivery?
  validates :delivery_postcode, :postcode => true, :if => :current_step_delivery?
  validates :billing_address1, :billing_city, :billing_postcode, :billing_country,  :presence => true, :if => :current_step_billing?
  validates :billing_postcode, :postcode => true, :if => :current_step_billing?
  validate  :credit_card_is_valid, :if => :current_step_billing? 
  
  before_validation :set_amount
  before_validation :set_billing_name
  
  accepts_nested_attributes_for :user
  
  class << self
    
    def number_of_snacks(box_type)
      case box_type
      when "taster" then "8-10"
      when "multi"  then "16-20"
      else
        ""
      end
    end
  
    def cost_in_pence(box_type,number_of_months)
      Order::COST_MATRIX[box_type.to_sym].try(:[], number_of_months).to_i
    end
  
    def cost(box_type,number_of_months)
      YmCore::Model::AmountAccessor::Float.new((self.cost_in_pence(box_type,number_of_months).to_f / 100).round(2))
    end
    
    def saving_in_pence(box_type,number_of_months)
      (cost_in_pence(box_type,1) * number_of_months) - cost_in_pence(box_type,number_of_months)
    end
    
    def saving_percentage(box_type,number_of_months)
      ((saving_in_pence(box_type,number_of_months).to_f / cost_in_pence(box_type,number_of_months)) * 100).to_i
    end
    
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
  
  def box_type_and_number_of_months
    [box_type,number_of_months].compact.join('-')
  end
  
  def box_type_and_number_of_months=(value)
    self.box_type, self.number_of_months = value.split('-')
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
  
  def billing_country
    "GB"
  end  
  
  def delivery_country
    "GB"
  end  
  
  def next_delivery_date
    next_shipping_date + 5.days
  end
  
  def next_shipping_date
    if Date.today.day < shipping_day
      # Hasn't been shipped yet this month
      Date.today.change(:day => shipping_day)
    else
      # Will be shipped next month
      (Date.today >> 1).change(:day => shipping_day)
    end
  end
  
  def product
    "#{box_type.capitalize} Box for #{number_of_months} month#{'s' if number_of_months > 1}"
  end
  
  def shipping_day
    Date.today.day < 15 ? 25 : 11
  end
  
  def failed?
    [vps_transaction_id,security_key,transaction_auth_number].any?(:blank?)
  end
  
  def successful?
    !failed?
  end
  
  def steps
    %w{box register delivery billing confirm}
  end
  
  def take_payment!
    if credit_card.valid?
      paypal_response = gateway.purchase(
      amount_in_pence,
      credit_card,
      :order_id => (Rails.env.development? ? "dev#{id}" : id),
      :billing_address => {
        :name => billing_name,
        :address1 => billing_address1,
        :address2 => billing_address2,
        :city => billing_city,
        :zip => billing_postcode,
        :country => billing_country
      }
      )
      process_response(paypal_response,self)
    end
  end
  
  def take_repeat_payment!
    repeat = self.class.create(attributes.symbolize_keys.slice(:amount_in_pence, :user_id).merge({:original_transaction_id => id}))
    
    paypal_response = gateway.repeat(
    amount_in_pence,
    :order_id => repeat.id,
    :related_transaction => attributes.symbolize_keys.slice(:id,:vps_transaction_id,:security_key,:transaction_auth_number)
    )
    
    process_response(paypal_response,repeat)
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
  
  def process_response(paypal_response,transaction)
    logger.info paypal_response.inspect
    if paypal_response.success?
      transaction.update_attributes(
      :vps_transaction_id => paypal_response.params["VPSTxId"],
      :security_key => paypal_response.params["SecurityKey"],
      :transaction_auth_number => paypal_response.params["TxAuthNo"]
      )
    end
  end
  
  def set_billing_name
    self.billing_name = credit_card.name
  end
  
  def set_amount
    self.amount_in_pence = Order.cost_in_pence(box_type,number_of_months)
  end
  
  
end

Order::COST_MATRIX = {
  :taster => { 1 =>  1295, 3 =>  3500, 6 =>   6500, 12 => 12500 },
  :multi  => { 1 =>  2500, 3 =>  6800, 6 =>  12800, 12 => 24500 }
}