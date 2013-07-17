class AddMorePricesToAvailableOrderOptions < ActiveRecord::Migration
  def change
    rename_column :available_order_options, :mini_price_in_pence, :mini_price_for_one_delivery_in_pence
    rename_column :available_order_options, :standard_price_in_pence, :standard_price_for_one_delivery_in_pence
    add_column :available_order_options, :mini_price_for_three_deliveries_in_pence, :integer
    add_column :available_order_options, :standard_price_for_three_deliveries_in_pence, :integer
    add_column :available_order_options, :mini_price_for_six_deliveries_in_pence, :integer
    add_column :available_order_options, :standard_price_for_six_deliveries_in_pence, :integer
  end
end
