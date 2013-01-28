class BoxesController < ApplicationController
  load_and_authorize_resource

  def show
    @box = Box.new(params[:year], params[:month], params[:type])
    if !Box.types.include?(@box.type) || @box.type == 'both'
      not_found
    else
      @products = @box.products
    end
  end
  
  def latest
    last = Product.where("month = ? AND year= ?", Box.latest_month, Box.latest_year).order(:year, :month).last
    redirect_to box_path(:year => last.year, :month => last.month, :type => 'standard')
  end
  
end  