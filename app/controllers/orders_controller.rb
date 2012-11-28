class OrdersController < ApplicationController
  load_and_authorize_resource
  
  def new
    @order = Order.new(:gift => params[:gift].present?)
  end
  
  def create
    @order = Order.new(params[:order])
    handle_order
  end
  
  def list
    @orders = Order.alphabetical_by_user
  end
  
  def index
    @orders = current_user.orders.order("created_at DESC")
  end
  
  def update
    @order.assign_attributes(params[:order])
    if @order.editing_by_admin
      if @order.save
        redirect_to list_orders_path
      else
        render :action => 'edit'
      end
    else
      handle_order
    end
  end
  
  private
  def handle_order
    if params[:back]
      @order.valid?
      @order.previous_step!
      @order.previous_step! if @order.current_step_register?
      render :action => "new"
    elsif params[:discount_code]
      @order.valid?
      render :action => "new"
    else
      if @order.current_step_register? && @order.login_email.present?
        user = User.find_by_email(@order.login_email)
        if user && user.valid_password?(@order.login_password)
          @order.user = user
          sign_in(:user,user)
        else
          invalid_login = true
        end
      end
      if @order.valid?
        if @order.last_step?
          @order.status = "failed"
          @order.save
          if success_or_error = @order.take_payment!
            @order.update_attribute(:status,'active')
            render :action => 'thanks'
          else
            flash[:error] = "Your payment could not be processed"
            @order.current_step = "billing"
            render :action => 'new'
          end
        else
          if @order.current_step_register?
            user = @order.user
            user.save
            sign_in(user)
            @order.user_id = user.id
          end
          @order.next_step!
          if @order.current_step_register?
            if current_user
              @order.user = current_user
              @order.next_step!
            else
              @order.user = User.new
            end
          end
          case @order.current_step
          when "delivery"
            if !@order.gift?
              if previous_order = @order.user.orders.where(:gift => false).first
                @order.delivery_name = previous_order.delivery_name
                @order.delivery_address1 = previous_order.delivery_address1
                @order.delivery_address2 = previous_order.delivery_address2
                @order.delivery_country = previous_order.delivery_country
                @order.delivery_city = previous_order.delivery_city
                @order.delivery_postcode = previous_order.delivery_postcode
              else
                @order.delivery_name = @order.user.full_name
              end
            end
          when "billing"
            @order.set_test_card_details
            @order.set_billing_address_from_delivery_address
            @order.credit_card.name = current_user.full_name if @order.credit_card.blank?
          end
          render :action => 'new'
        end
      else
        @order.errors.add(:login_email, "invalid email address or password") if invalid_login
        render :action => 'new'
      end
    end
    
  end
end