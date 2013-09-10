class ShippingDatesController < ApplicationController
  def show
    @shipping_date = ShippingDate.find_by_param(params[:id])
    authorize! :show, @shipping_date
    order_options = [[nil, "classic"]] + AvailableOrderOption.order("created_at DESC").map{|aoo| [aoo.id, aoo.option]}
    respond_to do |format|
      format.html do
        @deliveries = [].tap do |deliveries|
          [:mini,:standard].each do |box_type|
            order_options.each do |option|
              deliveries << [box_type, option, @shipping_date.deliveries.where(:box_type => box_type, :option_id => option.first)]
            end
          end
        end
      end
      format.xls do
        order_option = order_options.select{|option| option[0].to_s == params[:option_id].to_s}.first
        headers["Content-Disposition"] = "attachment; filename=\"#{params[:id]}-#{params[:box]}-#{order_option.last.parameterize}.xls\"" 
        @deliveries = @shipping_date.deliveries.where(:box_type => params[:box], :option_id => order_option.first)
        @shipping_date.update_downloaded(params[:box])
      end
    end
  end
end