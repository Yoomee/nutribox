class CreateOrderOptions < ActiveRecord::Migration
  def change
    create_table :order_options do |t|
      t.references :order
      t.references :available_order_option

      t.timestamps
    end
    add_index :order_options, [:order_id, :available_order_option_id]
  end
end
