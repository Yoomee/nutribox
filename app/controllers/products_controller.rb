class ProductsController < ApplicationController
  load_and_authorize_resource
  expose(:product)
  
  def create
    product.save ? redirect_to(products_month_path(product)) : render(:action => 'new')
  end
  
  def edit
  end
  
  def destroy
    product.destroy
    flash_notice(product)
    redirect_to(performers_path)
  end
  
  def update
    product.update_attributes(params[:product]) ? redirect_to(products_path) : render(:action => 'edit')
  end
  
  def months
    @months = Product.find(:all, :select => 'count(*) as count, year, month', :group=>'year, month', :order=>'year, month')        
  end
  
  def month
    @month = params[:yearmonth].to_i % 100
    @year = (params[:yearmonth].to_i/100).to_i
    @month_name=Date::MONTHNAMES[@month]
    @products = Product.where(:month => @month, :year => @year)   
  end
  
  private
  def products_month_path(product)
    "/products/month/#{product.year}#{'%02d' % product.month}"
  end
  
end