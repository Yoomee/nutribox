class SurveyAnswersController < ApplicationController
  
 def rate   
   if params[:survey_id].to_i.zero?
     @rating = SurveyAnswer.new(:survey => Survey.new(), :product_id => params[:product_id], :rating => params[:rating])   
   else
     @rating = SurveyAnswer.find_or_initialize_by_survey_id_and_product_id(params[:survey_id],params[:product_id])
     @rating.update_attribute(:rating, params[:rating])
   end
 end
 
 def comment   
   @survey = Survey.find(params[:survey_id])
   @product = Product.find(params[:product_id])
   @rating = SurveyAnswer.find_or_initialize_by_survey_id_and_product_id(@survey.id, @product.id)
   @rating.update_attribute(:comment, params[:comment])
 end
 
 def update
   @rating = SurveyAnswer.find_or_initialize_by_survey_id_and_product_id(params[:survey_answer][:survey_id],params[:survey_answer][:product_id])
   @rating.comment = params[:survey_answer][:comment]
   @rating.save
 end

 def create
   update
   render "update"
 end
 
  
end