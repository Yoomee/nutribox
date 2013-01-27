class Box
  
  include CanCan::Ability

  def initialize(month, year, type)
    @month = month
    @year = year
    @type = type
  end
  
  def in_the_future?
    false
  end
  
  def self.types
    ["mini", "standard", "both"]
  end
  
  
  
end