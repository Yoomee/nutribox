class SurveyAnswer < ActiveRecord::Base
  
  belongs_to :survey
  belongs_to :product
  
end
