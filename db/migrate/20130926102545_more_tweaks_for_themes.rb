class MoreTweaksForThemes < ActiveRecord::Migration
  def up
    YmSnippets::Snippet.find_by_slug('default_discount_message').update_attributes(:text => 'Prices from &pound;12.95 per box. Order today and get 25% OFF your first box.')
    change_column :available_order_options, :description, :text
    AvailableOrderOption.reset_column_information
    AvailableOrderOption.find(4).update_attributes(:name => 'The Classic', :description => "<p>The classic is the original Nutribox - a selection of 10 or 20 healthy snacks including fruit and nut mixes, energy bars and balls, and raw chocolate and other treats. <p><a href='/boxes'>Click here</a> to see what types of snacks you might get.</p>The healthy vending machine on your desk or at home to keep you going.</p>")
    AvailableOrderOption.find(1).update_attributes(:name => 'The Vegan', :description => "<p>If you choose to follow a vegan diet and lifestyle this box is for you - all the snacks are free from animal products and by products.</p><p><a href='/boxes'>Click here</a>&nbsp;to see what types of snacks you might get. </p>")
    AvailableOrderOption.find(5).update_attributes(:name => 'The Sports Nutrition', :description => "<p>If you train regularly and take your sport seriously this box provides you with high energy snacks for post training glycogen replacement and high protein snacks to meet your muscle growth and repair needs</p><p><a href='/boxes'>Click here</a>&nbsp;to see what types of snacks you might get.</p>")
    AvailableOrderOption.update_all(
                                    :mini_price_for_one_delivery_in_pence => 1295,
                                    :standard_price_for_one_delivery_in_pence => 2500,
                                    :mini_price_for_three_deliveries_in_pence => 1250,
                                    :standard_price_for_three_deliveries_in_pence => 2400,
                                    :mini_price_for_six_deliveries_in_pence => 1195,
                                    :standard_price_for_six_deliveries_in_pence => 2300,
                                    :mini_price_for_twelve_deliveries_in_pence => 1150,
                                    :standard_price_for_twelve_deliveries_in_pence => 2200,
                                    :mini_price_for_twenty_four_deliveries_in_pence => 1095,
                                    :standard_price_for_twenty_four_deliveries_in_pence => 2100
                                    )
  end

  def down
    YmSnippets::Snippet.find_by_slug('default_discount_message').update_attributes(:text => 'Order Today and Get 25% OFF your first box!')
  end
end
