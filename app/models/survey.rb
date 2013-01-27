class Survey < ActiveRecord::Base
    
  include CanCan::Ability
  belongs_to :user
    
  def self.create_new(delivery_id)
    delivery = Delivery.find(delivery_id)
    survey = Survey.new
    survey.delivery_id=delivery.id
    survey.email = delivery.user.email
    survey.user_id = delivery.user.id
    survey.year = Box.latest_year
    survey.month = Box.latest_month
    survey.box_type = delivery.box_type
    survey.hash = Digest::SHA1.hexdigest("#{delivery.id}/#{survey.year}/#{survey.month}")
    survey.save if Survey.find_by_hash(survey.hash).nil?
    survey
  end
  
end
