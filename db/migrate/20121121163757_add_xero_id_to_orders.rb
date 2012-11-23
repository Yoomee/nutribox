class AddXeroIdToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :xero_id, :string
  end
end
