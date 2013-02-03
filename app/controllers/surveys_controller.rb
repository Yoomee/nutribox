class SurveysController < ApplicationController
  
  def show
    @delivery = Delivery.find_by_survey_hash(params[:id])
    if @delivery.nil? then
      not_found
    else
      @survey = @delivery.find_or_create_survey
    end
  end  
  
  def preview
    @survey = Survey.new()
    @survey.id = 0
    @survey.month = params[:month]
    @survey.year = params[:year]
    @survey.box_type = params[:box_type]
    render :show
  end
  
  def index
    @months = Product.find(:all, :select => 'count(*) as count, year, month', :group=>'year, month', :order=>'year, month')
  end
  
  def recipients
    @month = params[:month].to_i
    @year = params[:year].to_i
    @deliveries = Delivery.by_month_and_year(@month,@year)
  end
  
  def results
    @month = params[:month].to_i
    @year = params[:year].to_i
    @products = Product.where("month = ? AND year= ?", @month, @year).order(:name)
  end
  
end