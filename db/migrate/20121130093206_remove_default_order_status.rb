class RemoveDefaultOrderStatus < ActiveRecord::Migration
  def change
    change_column_default :orders, :status, nil
  end
end
