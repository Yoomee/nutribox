class AlterAvailableOrderOption < ActiveRecord::Migration
  def change
  	rename_column :available_order_options, :option, :name
  	add_column :available_order_options, :description, :string
  	add_column :available_order_options, :image_uid, :string
  	add_column :available_order_options, :mini_price_in_pence, :integer
  	add_column :available_order_options, :standard_price_in_pence, :integer
  end
end
