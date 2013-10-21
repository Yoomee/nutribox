class ShippingDatesController < ApplicationController
  def show
    @shipping_date = ShippingDate.find_by_param(params[:id])
    authorize! :show, @shipping_date
    respond_to do |format|
      format.html do
        @deliveries = @shipping_date.deliveries
      end
      format.xls do
        headers["Content-Disposition"] = "attachment; filename=\"#{params[:id]}-#{AvailableOrderOption.find_by_id(params[:theme_id]).filename}-#{params[:box_type]}.xls\"" 
        @deliveries = @shipping_date.deliveries.joins(:order).where(:box_type => params[:box_type], :orders => {:theme_id => params[:theme_id]})
      end
    end
  end
end