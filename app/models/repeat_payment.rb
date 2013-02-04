class RepeatPayment < ActiveRecord::Base
  include YmCore::Model
  include Xero::Order
  
  amount_accessor 
  
  belongs_to :order
  validate :only_one_repeat_payment_per_month
  
  delegate :user, :gift?, :to => :order
  
  
  def amount_ex_vat
    unrounded = amount.to_f * ((100 - Order::VAT_PERCENTAGES[order.box_type.to_sym]) / 100.to_f)
    # Round down for tax purposes
    (unrounded * 100).floor / 100.0
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
  
  private
  def only_one_repeat_payment_per_month
    if order.repeat_payments.without(self).exists?(["YEAR(created_at) = ? AND MONTH(created_at) = ?",Date.today.year,Date.today.month])
      self.errors.add(:order, "- The payment for this order has already been repeated this month")
    end
  end

end