class Order < ActiveRecord::Base
  include YmCore::Model
  include YmCore::Multistep
    
  belongs_to :user
  belongs_to :delivery_address, :class_name => "Address"
  accepts_nested_attributes_for :delivery_address, :reject_if => proc { |attributes| attributes.all?{|k,v| v.blank?}}
  
  amount_accessor

  validates :user, :box_type, :number_of_months, :presence => true, :if => :current_step_box?
  validates :billing_address1, :billing_city, :billing_postcode, :billing_country,  :presence => true, :if => :current_step_billing?
  validate :credit_card_is_valid, :if => :current_step_billing? 
  
  before_validation :set_amount
  before_validation :set_billing_name
  
  def self.cost_in_pence(box_type,number_of_months)
    cost_matrix = {
      :taster =>  { 1 =>  1295, 3 =>  3500, 6 =>   6500, 12 => 12500 },
      :booster => { 1 =>  2500, 3 =>  6800, 6 =>  12800, 12 => 24500 }
    }
    cost_matrix[box_type.to_sym].try(:[], number_of_months).to_i
  end
  
  def set_billing_address_from_delivery_address
    if billing_address1.blank?
      self.billing_address1 = delivery_address.address1
      self.billing_address2 = delivery_address.address2
      self.billing_city = delivery_address.city
      self.billing_postcode = delivery_address.postcode
      self.billing_country = delivery_address.country
    end
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
  
  def failed?
    [vps_transaction_id,security_key,transaction_auth_number].any?(:blank?)
  end
  
  def successful?
    !failed?
  end
  
  def steps
    %w{box delivery billing confirm}
  end
  
  def take_payment!
    if credit_card.valid?
      paypal_response = gateway.purchase(
      amount_in_pence,
      credit_card,
      :order_id => id,
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

Order::BOX_TYPES = ['taster','booster']