class DiscountCode < ActiveRecord::Base
  validates :code, :percentage, :presence => true
  validates :code, :uniqueness => true
  validates :percentage, :numericality => {:only_integer => true, :greater_than => 0, :less_than_or_equal_to => 100}
  validates :number_available, :numericality => {:only_integer => true, :greater_than => 0}, :allow_blank => true
  
  has_many :orders, :primary_key => :code, :foreign_key => :discount_code_code, :conditions => "orders.status != 'failed'"
  
  def available?
    !expired && (remaining.blank? || ( remaining > 0))
  end
  
  def available_to?(user)
    available? && (user.nil? || true)
  end
  
  def claimed
    orders.count
  end
  
  def fraction
    percentage / 100.to_f
  end
  
  def remaining
    number_available.present? ? (number_available - claimed) : nil
  end
  
  def used_by_user?(user)
    orders.exists?(:user_id => user.id)
  end
  
  def used_by_credit_card_number?(credit_card_number)
    orders.exists?(:encrypted_credit_card_number => Order.encrypt_credit_card_number(credit_card_number))
  end
  
end