class BoxesController < ApplicationController
  load_and_authorize_resource

  def show
    @type = params[:type]
    @year = params[:year].to_i
    @month = params[:month].to_i
    if !Box.types.include?(@type) || @type == 'both'
      not_found
    else
      @box = Box.new(@year, @month, @type)
      if @month == 0
          redirect_to box_path(:year => @year-1, :month => 12, :type => @type)
      elsif @month == 13
        redirect_to box_path(:year => @year+1, :month => 1, :type => @type)
      else
        @products = Product.where("month = ? AND year= ? AND (box_type = ? OR box_type ='both')", @month, @year, @type).order(:name)
      end
    end
    
  end
  
  private
  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end
  
end  