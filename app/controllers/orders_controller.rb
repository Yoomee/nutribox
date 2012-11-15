"delivery_address_id"
class OrdersController < ApplicationController
  load_and_authorize_resource
  
  def new
    @order = current_user.orders.build
  end
  
  def create
    prepare_for_order
    @order = Order.new(params[:order])
    @order.user = current_user
    handle_order
  end
  
  def update
    prepare_for_order
    @order.assign_attributes(params[:order])
    handle_order
  end
  
  private
  def prepare_for_order
    unless params[:order][:delivery_address_id].to_i.zero?
      order_params = params[:order]
      order_params.delete(:delivery_address_attributes)
      params[:order] = order_params
    end
  end
  
  def handle_order
    if params[:back]
      @order.previous_step!
      render :action => "new"
    else
      if @order.valid?
        if @order.last_step?
          @order.save
          if @order.take_payment!
            redirect_to @order
          else
            flash[:error] = "Payment error"
            render :action => 'new'
          end
        else
          if @order.current_step_box? && @order.delivery_address.nil?
            @order.delivery_address = @order.user.addresses.build
          end
          if @order.current_step_delivery?
            @order.set_test_card_details
            @order.set_billing_address_from_delivery_address
            @order.credit_card.name = current_user.full_name if @order.credit_card.blank?
          end
          @order.next_step!
          render :action => 'new'
        end
      else
        render :action => 'new'
      end
    end
    
  end
end