class AddDefaultToNumberOfDeliveriesPaidForEachBillingOnOrder < ActiveRecord::Migration
  def change
    change_column_default :orders, :number_of_deliveries_paid_for_each_billing, 1
  end
end
