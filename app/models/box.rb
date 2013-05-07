class Box
  
  attr_accessor :month, :year, :type

  def initialize(year, month, type)
    @month = month.to_i
    @year = year.to_i
    @type = type
  end
  
  def products
    Product.where("month = ? AND year= ? AND (box_type = ? OR box_type ='both')", @month, @year, @type).order(:name)
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
    Date.today < Date.new(@year,@month,SURVEY_DAY)
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
  
  def self.latest_month
    if DateTime.now.day < SURVEY_DAY 
      (DateTime.now - 1.month).month
    else
      DateTime.now.month
    end
  end
  
  def self.latest_year
    if DateTime.now.day < SURVEY_DAY 
      (DateTime.now - 1.month).year
    else
      DateTime.now.year
    end
  end
  
SURVEY_DAY = 28
  
end