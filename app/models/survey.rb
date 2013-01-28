class Survey < ActiveRecord::Base
    
  include CanCan::Ability
  belongs_to :user
    
  def self.create_new(delivery_id)
    delivery = Delivery.find(delivery_id)
    survey = Survey.new
    survey.delivery_id=delivery.id
    survey.save if Survey.find_by_delivery_id(delivery.id).nil?
    survey
  end
  
end
