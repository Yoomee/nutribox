FactoryGirl.define do
  
  factory :order do |f|  
    f.box_type 'standard'
    f.theme_id 1
    f.number_of_deliveries_paid_for_each_billing 1
    f.full_price_amount_in_pence 1395
    f.delivery_address1 '6 Aldreth Grove'
    f.delivery_city 'York'
    f.delivery_postcode 'YO23 1LB'
    f.delivery_country 'GB'
  end
  
  factory :user do |f|
    f.first_name "Charles"
    f.last_name "Barrett"
    f.email "charles@barrett.com"
    f.password "password"
  end

  factory :available_order_option do |f|
   f.name 'The Nutribox'
   f.position 1
   f.mini_price_for_one_delivery_in_pence 1395
   f.standard_price_for_one_delivery_in_pence 2700
   f.mini_price_for_three_deliveries_in_pence 1295
   f.standard_price_for_three_deliveries_in_pence 2500
   f.mini_price_for_six_deliveries_in_pence 1195
   f.standard_price_for_six_deliveries_in_pence 2300
   f.mini_price_for_twelve_deliveries_in_pence 1150
   f.standard_price_for_twelve_deliveries_in_pence 2200
   f.mini_price_for_twenty_four_deliveries_in_pence 1095
   f.standard_price_for_twenty_four_deliveries_in_pence 210
  end
  
end