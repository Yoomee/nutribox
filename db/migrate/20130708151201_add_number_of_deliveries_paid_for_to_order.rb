class AddNumberOfDeliveriesPaidForToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :number_of_deliveries_paid_for, :integer
    Order.reset_column_information
    Order.all.each do |order|
    	order.update_attribute(:number_of_deliveries_paid_for, (order.number_of_months + (order.number_of_months * order.repeat_payments.count))) 
    end
  end
end
