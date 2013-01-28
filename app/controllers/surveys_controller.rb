class SurveysController < ApplicationController
  
  def show
    @delivery = Delivery.find_by_survey_hash(params[:id])
    if @delivery.nil? then
      not_found
    else
      @survey = @delivery.find_or_create_survey
    end
  end  
  
  def create_from_delivery
    @survey = Survey.create_new(params[:id])
    redirect_to survey_path(:id => @survey.hash)
  end
  
end