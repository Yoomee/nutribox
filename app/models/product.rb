class Product < ActiveRecord::Base
  
  include CanCan::Ability
  image_accessor :image    
  
  validates :name, :description, :month, :year, :box_type, :image, :presence => true
  
  
  def self.months
    months = []
    (1..12).each {|m| months << [Date::MONTHNAMES[m], m]}
    months
  end
  
  def self.years
    years = []
    10.times {|count| years << Time.now.year+count}
    years
  end
  
  def self.get_month(yearmonth)
    yearmonth.to_i % 100
  end
  
  def self.get_year(yearmonth)
    (yearmonth.to_i/100).to_i
  end
  
end
