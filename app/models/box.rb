class Box
  
  include CanCan::Ability
  attr_accessor :month, :year, :type

  def initialize(year, month, type)
    @month = month.to_i
    @year = year.to_i
    @type = type
  end
  
  def previous_month
    ("1/#{@month}/#{@year}".to_datetime - 1.month).month
  end
  
  def next_month
    ("1/#{@month}/#{@year}".to_datetime + 1.month).month
  end
  
  def previous_year
    ("1/#{@month}/#{@year}".to_datetime - 1.month).year
  end
  
  def next_year
    ("1/#{@month}/#{@year}".to_datetime + 1.month).year
  end
  
  def in_the_future?
    return false if @year < Time.now.year
    return true if @month > Time.now.month
    return false if Time.now.day > SHIPPING_DAY
    true
  end
    
  def last_box?
    Product.where("month = ? AND year= ? AND (box_type = ? OR box_type ='both')", next_month, next_year, @type).empty?
  end  
  
  def first_box?
    Product.where("month = ? AND year= ? AND (box_type = ? OR box_type ='both')", previous_month, previous_year, @btype).empty?
  end
    
  def self.types
    ["mini", "standard", "both"]
  end
  
SHIPPING_DAY = 11
  
end