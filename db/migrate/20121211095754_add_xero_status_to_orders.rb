class AddXeroStatusToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :xero_status, :string, :default => "pending"
  end
end
