class AddHashIdToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :hash_id, :string, :after => :user_id
    @orders = Order.order("created_at DESC")
    @orders.each do |order|
      order.set_hash_id
      order.save
    end       
  end
end
