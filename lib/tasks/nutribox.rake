namespace :nutribox do
  
  desc 'Create a shipping date and generate deliveries'
  task :ship => :environment do
    if Date.today.day.in?([11,25])
      ShippingDate.create(:date => Date.today)
    end
  end
  
end
