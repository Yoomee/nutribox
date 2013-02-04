namespace :nutribox do
  
  desc 'Create a shipping date and generate deliveries'
  task :ship => :environment do
    if Date.today.day.in?([2,16])
      Order.active.where("orders.gift = 1 OR orders.number_of_months > 1").each do |order|
        if order.deliveries.count >= order.number_of_months
          order.update_attribute(:status,"ended")
        end
      end
      Order.active.reload
      ShippingDate.create(:date => 9.days.from_now)
    end
  end  
  
  desc 'Sync orders with Xero'
  task :xero => :environment do
    Order.where("status = 'active' AND xero_status != 'success'").each do |order|
      order.sync_with_xero
    end
  end
  
  desc 'Take repeat payments'
  task :repeat => :environment do
    if Date.today.day.in?([1,15])
      Order.repeatable_for_shipping_day(Date.today.day + 10).each do |order|
        order.take_repeat_payment!
      end
    end
  end
  
  
end
