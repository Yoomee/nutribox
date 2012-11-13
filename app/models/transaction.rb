class Transaction < ActiveRecord::Base
    
  belongs_to :user
  belongs_to :credit_card_details
  
  delegate :credit_card, :billing_address, :to => :credit_card_details
  
  def take_payment!
    if credit_card.valid?
      response = gateway.purchase(amount_in_pence, credit_card, :order_id => id, :billing_address => billing_address)
      puts response.inspect
      if response.success?
        update_attributes(
          :vps_transaction_id => response.params["VPSTxId"],
          :security_key => response.params["SecurityKey"],
          :transaction_auth_number => response.params["TxAuthNo"]
        )
      end
    end
  end
  
  def take_repeat_payment!
    repeat = Transaction.create(attributes.symbolize_keys.slice(:amount_in_pence, :user_id, :credit_card_details_id))
    
    transaction_attrs = attributes.symbolize_keys.slice(:id,:vps_transaction_id,:security_key,:transaction_auth_number)
    
    response = gateway.repeat(amount_in_pence, credit_card, :order_id => repeat.id, :related_transaction => transaction_attrs)
    
    puts response.inspect
    
  end
  
  private
  def gateway
    @gateway ||= begin
      gwy = ActiveMerchant::Billing::SagePayGateway.new(:login => Settings.sage_pay_vendor_name)
      #gwy = ActiveMerchant::Billing::SagePayGateway.new(:login => "yoomeedeveloper")#Settings.sage_pay_vendor_name)
      #gwy.simulate = true
      gwy
    end
  end
  
end