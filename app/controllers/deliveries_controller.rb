class DeliveriesController < ApplicationController
  load_and_authorize_resource

  def update
    if @delivery.repeat_repeat_payment!
      flash[:notice] = "Payment for #{@delivery.user} taken successfully."
    else
      flash[:error] = "Payment for #{@delivery.user} unsuccessful again."
    end
    redirect_to @delivery.shipping_date
  end

end