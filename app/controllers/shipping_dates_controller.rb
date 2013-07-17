class ShippingDatesController < ApplicationController
  def show
    @shipping_date = ShippingDate.find_by_param(params[:id])
    authorize! :show, @shipping_date
    respond_to do |format|
      format.html do
        @deliveries = @shipping_date.deliveries #[:mini,:standard].map{|box_type| [box_type,@shipping_date.deliveries.where(:box_type => box_type)]}
      end
      format.xls do
        headers["Content-Disposition"] = "attachment; filename=\"#{params[:id]}-#{params[:box]}.xls\"" 
        @deliveries = @shipping_date.deliveries.joins(:order).where(:box_type => params[:box], :orders => {:theme_id => params[:theme_id]})
        # @shipping_date.update_downloaded(params[:box])
      end
    end
  end
end