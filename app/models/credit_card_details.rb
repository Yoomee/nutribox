class CreditCardDetails < ActiveRecord::Base
  
  belongs_to :user
  
  attr_accessor :verification_value
  
  def self.test_card_details
    new(
    :name => 'Bob Bobsen',
    :number => '4929000000006',
    :month => '8',
    :year => '2013',
    :verification_value => '123',
    :address1 => 88,
    :city => "London",
    :zip => 412,
    :country => "GB"
    )
  end
  
  def billing_address
    attributes.symbolize_keys.slice(:name,:address1,:address2,:city,:country,:zip)
  end
  
  def credit_card
    @credit_card ||= begin
      card = ActiveMerchant::Billing::CreditCard.new(attributes.symbolize_keys.slice(:name,:number,:month,:year))
      card.verification_value = verification_value
      card
    end
  end
end