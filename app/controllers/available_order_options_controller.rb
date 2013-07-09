class AvailableOrderOptionsController < ApplicationController
  load_and_authorize_resource

  def create
    if @available_order_option.save
      redirect_to available_order_options_path
    else      
      render :action => 'new'
    end
  end

  def new    
     
  end

  def index
    @available_order_options = AvailableOrderOption.order("created_at DESC")

  end

  def destroy
    @available_order_option.destroy
    redirect_to available_order_options_path
  end

  def edit

  end

  def update
    if @available_order_option.update_attributes(params[:available_order_option])
      redirect_to available_order_options_path
    else
      render :action => 'edit'
    end
  end

end