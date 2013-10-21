class AddFrequencyToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :frequency, :string, :default => 'monthly'
  end
end
