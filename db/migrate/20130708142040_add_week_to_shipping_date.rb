class AddWeekToShippingDate < ActiveRecord::Migration
  def change
    add_column :shipping_dates, :week, :integer
  end
end
