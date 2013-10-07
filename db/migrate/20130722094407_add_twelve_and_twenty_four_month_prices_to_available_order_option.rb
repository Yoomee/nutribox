class AddTwelveAndTwentyFourMonthPricesToAvailableOrderOption < ActiveRecord::Migration
  def change
    add_column :available_order_options, :mini_price_for_twelve_deliveries_in_pence, :integer
    add_column :available_order_options, :standard_price_for_twelve_deliveries_in_pence, :integer
    add_column :available_order_options, :mini_price_for_twenty_four_deliveries_in_pence, :integer
    add_column :available_order_options, :standard_price_for_twenty_four_deliveries_in_pence, :integer
  end
end
