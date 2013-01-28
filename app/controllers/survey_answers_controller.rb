class SurveyAnswersController < ApplicationController
  
 def rate   
   @survey = Survey.find(params[:survey_id])
   @product = Product.find(params[:product_id])
   @rating = SurveyAnswer.find_or_initialize_by_survey_id_and_product_id(@survey.id, @product.id)
   @rating.update_attribute(:rating, params[:rating])
   
 end
  
end