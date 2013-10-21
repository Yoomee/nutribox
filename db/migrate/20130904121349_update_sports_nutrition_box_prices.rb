class UpdateSportsNutritionBoxPrices < ActiveRecord::Migration
  def up
  	AvailableOrderOption.find_by_name('The sports performance').update_attributes(
  	:mini_price_for_one_delivery_in_pence => 1295,
  	:standard_price_for_one_delivery_in_pence => 2500,
  	:mini_price_for_three_deliveries_in_pence => 1250,
  	:standard_price_for_three_deliveries_in_pence => 2400,
  	:mini_price_for_six_deliveries_in_pence => 1195,
  	:standard_price_for_six_deliveries_in_pence => 2300,
  	:mini_price_for_twelve_deliveries_in_pence => 1150,
  	:standard_price_for_twelve_deliveries_in_pence => 2200,
  	:mini_price_for_twenty_four_deliveries_in_pence => 1095,
  	:standard_price_for_twenty_four_deliveries_in_pence => 2100)

  end

  def down
  end
end
