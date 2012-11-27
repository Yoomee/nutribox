class AddNumberOfMonthsAndGiftToDeliveries < ActiveRecord::Migration
  def change
    add_column :deliveries, :gift, :boolean, :after => :box_type
    add_column :deliveries, :number_of_months, :integer, :after => :box_type
  end
end
