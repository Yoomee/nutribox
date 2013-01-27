class SurveysController < ApplicationController
  
  def show
    @survey = Survey.find_by_hash(params[:id])
    @box = Box.new(@survey.year, @survey.month, @survey.box_type)
  end
  
  
  def create_from_delivery
    @survey = Survey.create_new(params[:id])
    redirect_to survey_path(:id => @survey.hash)
  end
  
end