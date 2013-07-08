class AddShippingWeekToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :shipping_week, :integer, :after => :shipping_day
    Order.reset_column_information
    Order.all.each do |order|
    	order.update_attribute(:shipping_week, 2) if order.shipping_day == 11
    	order.update_attribute(:shipping_week, 4) if order.shipping_day == 25
    end
  end
end
