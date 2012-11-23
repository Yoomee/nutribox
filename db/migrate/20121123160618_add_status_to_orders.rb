class AddStatusToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :status, :string, :default => "active", :after => :user_id
  end
end
