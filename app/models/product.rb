class Product < ActiveRecord::Base
  
  include CanCan::Ability
  image_accessor :image    
  
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
  
  def self.box_types
    ["Mini", "Standard", "Both"]
  end
  
end
