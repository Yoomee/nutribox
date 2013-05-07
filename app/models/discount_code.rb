class DiscountCode < ActiveRecord::Base
  validates :code, :percentage, :presence => true
  validates :code, :uniqueness => true
  validates :percentage, :numericality => {:only_integer => true, :greater_than => 0, :less_than_or_equal_to => 100}
  validates :number_available, :numericality => {:only_integer => true, :greater_than => 0}, :allow_blank => true
  
  has_many :orders, :primary_key => :code, :foreign_key => :discount_code_code, :conditions => "orders.status != 'failed'"
  
  def self.default
    if code = find_by_code("DEFAULT")
      return code
    else
      DiscountCode.create(:code => "DEFAULT", :percentage => 25)
    end
  end
  
  def available?
    !expired && (remaining.blank? || ( remaining > 0))
  end
  
  def available_to?(user)
    available? && (user.nil? || orders.where(:user_id => user.id).empty?)
  end
  
  def claimed
    orders.count
  end
  
  def percentage_with_default
    if code == "DEFAULT"
      percentage
    else
      percentage + DiscountCode.default.percentage
    end
  end
  
  def fraction
    percentage_with_default / 100.to_f
  end
  
  def remaining
    number_available.present? ? (number_available - claimed) : nil
  end
  
end