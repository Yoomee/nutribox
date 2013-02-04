class AddShippingDayToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :shipping_day, :integer
    Order.reset_column_information
    Order.all.each do |order|
      order.send(:set_shipping_day)
      order.save
    end
  end
end
