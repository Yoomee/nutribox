class Product < ActiveRecord::Base
  
  include CanCan::Ability
  image_accessor :image    
  
  def self.months
    @months = Array.new
    (1..12).each {|m| @months << [Date::MONTHNAMES[m], m]}
  end
  
end
