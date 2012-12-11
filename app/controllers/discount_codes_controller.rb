class DiscountCodesController < ApplicationController
  load_and_authorize_resource
  def index
    @discount_codes = DiscountCode.order("expired,created_at DESC")
  end
  
  def create
    @discount_code.save ? redirect_to(discount_codes_path) : render(:action => 'new')
  end
  
  def update
    @discount_code.update_attributes(params[:discount_code]) ? redirect_to(discount_codes_path) : render(:action => 'edit')
  end
  
end