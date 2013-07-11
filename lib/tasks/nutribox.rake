namespace :nutribox do
  
  desc 'Create a shipping date and generate deliveries'
  task :ship => :environment do
    if Date.today.wday == 5
      Order.active.where("orders.gift = 1 OR orders.number_of_months = 12").each do |order|
        if order.deliveries.count >= order.number_of_deliveries_paid_for
          order.update_attribute(:status,"ended")
        end
      end
      Order.active.reload
      ShippingDate.create(:date => Date.today)
    end
  end  
  
  desc 'Sync orders and repeat payments with Xero'
  task :xero => :environment do
    Order.where("status = 'active' AND (xero_status IS NULL OR xero_status != 'success')").each do |order|
      order.sync_with_xero
      sleep(2)
    end
    RepeatPayment.with_transaction_auth_number.where("xero_status IS NULL OR xero_status != 'success'").each do |repeat_payment|
      repeat_payment.sync_with_xero
      sleep(2)
    end
  end
  
  desc 'Take repeat payments'
  task :repeat => :environment do
    if Date.today.wday == 5
      Order.repeatable_by_week(Date.today).each do |order|
        order.take_repeat_payment!
      end
      RepeatPayment.with_transaction_auth_number.reload.where("xero_status IS NULL OR xero_status != 'success'").each do |repeat_payment|
        repeat_payment.sync_with_xero
        sleep(2)
      end
    end
  end
  
  
end
