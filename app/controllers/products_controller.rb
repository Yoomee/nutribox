class ProductsController < ApplicationController
  load_and_authorize_resource
  expose(:product)
  
  def create
    product.save ? redirect_to(products_month_path(:year =>product.year, :month=> product.month)) : render(:action => 'new')
  end
  
  def destroy
    product.destroy
    flash_notice(product)
    redirect_to(products_month_path(:year =>product.year, :month=> product.month))
  end
  
  def update
    product.update_attributes(params[:product]) ? redirect_to(products_month_path(:year =>product.year, :month=> product.month)) : render(:action => 'edit')
  end
  
  def index
    @months = Product.find(:all, :select => 'count(*) as count, year, month', :group=>'year, month', :order=>'year, month')        
  end 
  
  def month
    @month = params[:month].to_i
    @year = params[:year].to_i
    @month_name=Date::MONTHNAMES[@month]
    @products = Product.where(:month => @month, :year => @year)   
  end

end