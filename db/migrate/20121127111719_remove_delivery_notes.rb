class RemoveDeliveryNotes < ActiveRecord::Migration
  def change
    remove_column :orders, :delivery_notes
    remove_column :deliveries, :notes
  end
end
