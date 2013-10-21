class RenameNumberOfMonthsInOrders < ActiveRecord::Migration
  def change
    rename_column :orders, :number_of_months, :number_of_deliveries_paid_for_each_billing
  end
end
