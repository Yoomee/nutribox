class AddDeliveriesCountToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :deliveries_count, :integer, :null => false, :default => 0
    ids = Set.new
    Delivery.all.each {|d| ids << d.order_id}
    ids.each do |order_id|
      Order.reset_counters(order_id, :deliveries)
    end
  end
end
