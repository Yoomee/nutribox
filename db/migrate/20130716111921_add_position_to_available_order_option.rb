class AddPositionToAvailableOrderOption < ActiveRecord::Migration
  def change
    add_column :available_order_options, :position, :integer, :default => 0
  end
end
