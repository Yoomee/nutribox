module OrdersHelper
  
  def box_name(box_type)
    Order.box_name(box_type)
  end
  
  def gift_or_join_path(order)
    if order.gift?
      order.new_record? ? gift_path : update_gift_path(order)
    else
      order.new_record? ? join_path : update_join_path(order)
    end
  end
  
  def order_box_options
    Order::COST_MATRIX.keys.map{|b| ["#{b.capitalize} Box", b]}
  end
  
  def order_month_options
    [1,3,6,12].map{|n| [pluralize(n,'month'),n]}
  end
  
end