class HomeController < ApplicationController
  
  skip_before_filter :authenticate
  
  def index
  end

end