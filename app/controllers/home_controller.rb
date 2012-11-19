class HomeController < ApplicationController
  
  skip_before_filter :authenticate
  
  def index
    render :action => "logged_out_index" unless current_user || Rails.env.development?
  end

end