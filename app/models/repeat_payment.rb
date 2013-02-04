class RepeatPayment < ActiveRecord::Base
  include YmCore::Model
  
  belongs_to :order
  validate :only_one_repeat_payment_per_month
  
  private
  def only_one_repeat_payment_per_month
    if order.repeat_payments.without(self).exists?(["YEAR(created_at) = ? AND MONTH(created_at) = ?",Date.today.year,Date.today.month])
      self.errors.add(:order, "- The payment for this order has already been repeated this month")
    end
  end

end