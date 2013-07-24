namespace :nutribox do
  
  desc 'Create a shipping date and generate deliveries'
  task :ship => :environment do
    shipping_list_logger = Logger.new("#{Rails.root}/log/shipping_list.log")
    shipping_list_logger.info "\n\n____________________________________________________"
    shipping_list_logger.info "Create a shipping date and generate deliveries - #{Time.now}"
    if Date.today.day.in?([2,16])
      Order.active.where("orders.gift = 1 OR orders.number_of_months = 12").each do |order|
        if order.deliveries.count >= order.number_of_months
          order.update_attribute(:status,"ended")
          shipping_list_logger.info "Ended order ##{order.id}"
        end
      end
      Order.active.reload
      shipping_date = ShippingDate.create(:date => 9.days.from_now)
      shipping_list_logger.info "Created shipping_date ##{shipping_date.id}"
    end
  end  
  
  desc 'Sync orders and repeat payments with Xero'
  task :xero => :environment do
    payment_logger = Logger.new("#{Rails.root}/log/payments_and_sync.log")
    payment_logger.info "\n\n____________________________________________________"
    payment_logger.info "Sync orders and repeat payments with Xero - #{Time.now}"
    Order.where("status = 'active' AND (xero_status IS NULL OR xero_status != 'success')").each do |order|
      order.sync_with_xero
      payment_logger.info "Attempted xero sync for order ##{order.id}"
      sleep(2)
    end
    RepeatPayment.with_transaction_auth_number.where("xero_status IS NULL OR xero_status != 'success'").each do |repeat_payment|
      repeat_payment.sync_with_xero
      payment_logger.info "Attempted xero sync for repeat_payment ##{repeat_payment.id}"
      sleep(2)
    end
  end
  
  desc 'Take repeat payments and sync with Xero'
  task :repeat => :environment do
    payment_logger = Logger.new("#{Rails.root}/log/payments_and_sync.log")
    payment_logger.info "\n\n____________________________________________________"
    payment_logger.info "Take repeat payments and sync with Xero - #{Time.now}"
    if Date.today.day.in?([1,15])
      Order.repeatable_for_shipping_day_with_3_or_6_months(Date.today.day + 10).each do |order|
        order.take_repeat_payment!
        payment_logger.info "Attempted repeat payment for order ##{order.id}"
      end
      RepeatPayment.with_transaction_auth_number.reload.where("xero_status IS NULL OR xero_status != 'success'").each do |repeat_payment|
        repeat_payment.sync_with_xero
        payment_logger.info "Attempted xero sync for repeat_payment ##{repeat_payment.id}"
        sleep(2)
      end
    end
  end

end
