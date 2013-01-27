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
  
  private
  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end
  
end  