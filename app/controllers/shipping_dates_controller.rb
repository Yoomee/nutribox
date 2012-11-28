class ShippingDatesController < ApplicationController
  def show
    @shipping_date = ShippingDate.find_by_param(params[:id])
    authorize! :show, @shipping_date
    
    respond_to do |format|
      format.html
      format.xls do
        @shipping_date.update_attribute(:downloaded,true) unless @shipping_date.downloaded?
      end
    end
  end
end