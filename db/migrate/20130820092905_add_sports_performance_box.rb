class AddSportsPerformanceBox < ActiveRecord::Migration
  def up
  	AvailableOrderOption.create(
  		:name => 'The sports performance',
  		:position => 3,
  		:mini_price_for_one_delivery => '17.95',
  		:standard_price_for_one_delivery => '35.00',
  		:mini_price_for_three_deliveries => '16.95',
  		:standard_price_for_three_deliveries => '33.00',
  		:mini_price_for_six_deliveries => '15.95',
			:standard_price_for_six_deliveries => '31.00',
  		:mini_price_for_twelve_deliveries => '15.50',
  		:standard_price_for_twelve_deliveries => '30.00',
  		:mini_price_for_twenty_four_deliveries => '14.95',
  		:standard_price_for_twenty_four_deliveries => '29.00'
  		)
  end

  def down
  	AvailableOrderOption.find_by_name('The sports performance').destroy
  end
end
