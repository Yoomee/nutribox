namespace :nutribox do
  
  desc 'Create a shipping date and generate deliveries'
  task :ship => :environment do
    if Date.today.day.in?([11,25])
      ShippingDate.create(:date => Date.today)
    end
  end
  
  
  desc 'Sync orders with Xero'
  task :xero => :environment do
    Order.where("status = 'active' AND xero_status != 'success'").each do |order|
      order.sync_with_xero
    end
  end
  
end
