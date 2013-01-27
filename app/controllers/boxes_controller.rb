class BoxesController < ApplicationController
  load_and_authorize_resource

  def show
    @box = Box.new(params[:year], params[:month], params[:type])
    if !Box.types.include?(@box.type) || @box.type == 'both'
      not_found
    else
      @products = Product.where("month = ? AND year= ? AND (box_type = ? OR box_type ='both')", @box.month, @box.year, @box.type).order(:name)
    end
  end
  
  def latest
    last = Product.where("month = ? AND year= ?", Box.latest_month, Box.latest_year).order(:year, :month).last
    redirect_to box_path(:year => last.year, :month => last.month, :type => 'standard')
  end
  
  private
  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end
  
end  