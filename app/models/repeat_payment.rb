class RepeatPayment < ActiveRecord::Base
  include YmCore::Model
  include Xero::Order
  
  amount_accessor 
  
  belongs_to :order
  
  delegate :user, :gift?, :billing_address1, :billing_address2, :billing_city, :billing_postcode, :billing_country, :to => :order  
  scope :with_transaction_auth_number, where("transaction_auth_number IS NOT NULL AND transaction_auth_number != ''")
  scope :without_transaction_auth_number, where("transaction_auth_number IS NULL OR transaction_auth_number = ''")
  
  
  def amount_ex_vat
    unrounded = amount.to_f * ((100 - Order::VAT_PERCENTAGES[order.box_type.to_sym]) / 100.to_f)
    # Round down for tax purposes
    (unrounded * 100).floor / 100.0
  end
  
  def order_number
    Rails.env.development? ? "devR#{id}" : "NBR#{id}"
  end
  
  def product
    "#{order.product} - Repeat Payment"
  end
  
  def vat
    (amount - amount_ex_vat).round(2)
  end
  
  def xero_order_number
    Rails.env.development? ? "devR#{id}" : "NBR-#{id}"
  end

end