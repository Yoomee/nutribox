module OrdersHelper
  
  def order_box_options
    Order::BOX_TYPES.map{|b| ["#{b.capitalize} Box", b]}
  end
  
  def order_month_options
    [1,3,6,12].map{|n| [pluralize(n,'month'),n]}
  end
  
end