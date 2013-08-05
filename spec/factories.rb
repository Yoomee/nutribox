FactoryGirl.define do
  
  factory :order do |f|  
    f.box_type Order::COST_MATRIX.keys.first.to_s
    f.number_of_months 1
    f.full_price_amount_in_pence Order.cost_in_pence(Order::COST_MATRIX.keys.first.to_s,1)
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
  
end