class Box
  
  include CanCan::Ability

  
  def self.types
    ["Mini", "Standard", "Both"]
  end
  
  
  
end