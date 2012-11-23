class AddDeliveryNotesToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :delivery_notes, :text, :after => :delivery_country
  end
end
