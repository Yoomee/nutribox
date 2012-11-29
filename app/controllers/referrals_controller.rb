class ReferralsController < ApplicationController
  load_and_authorize_resource
    
  def new
    code = params[:code].upcase
    if User.exists?(:referral_code => code) && !current_user
      session[:referral_code] = code
    end
    @order = Order.new
    render :template => "orders/new"
  end
  
  def index
  end
  
end