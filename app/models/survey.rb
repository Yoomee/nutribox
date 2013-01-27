class Survey < ActiveRecord::Base
    
  include CanCan::Ability
  belongs_to :user
    
  def self.create_new(user)
    survey = Survey.new
    survey.email = user.email
    survey.user_id = user.id
    survey.year = Box.latest_year
    survey.month = Box.latest_month
    survey.box_type = 'standard'
    survey.hash = Digest::SHA1.hexdigest("#{survey.email}#/{survey.year}#/{survey.month}#/{survey.month}")
    if Survey.find_by_hash(survey.hash).nil?
      survey.save
    else
      survey
    end
  end
  
end
