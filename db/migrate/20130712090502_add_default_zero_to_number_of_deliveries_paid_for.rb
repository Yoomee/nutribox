class AddDefaultZeroToNumberOfDeliveriesPaidFor < ActiveRecord::Migration
  def change
    change_column_default :orders, :number_of_deliveries_paid_for, 0
  end
end
