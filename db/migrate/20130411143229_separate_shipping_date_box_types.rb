class SeparateShippingDateBoxTypes < ActiveRecord::Migration
  def change
    rename_column :shipping_dates, :downloaded, :downloaded_mini
    add_column :shipping_dates, :downloaded_standard, :boolean, :default => false, :after => :downloaded_mini
    ShippingDate.reset_column_information
    ShippingDate.update_all("downloaded_standard = downloaded_mini")
  end
end
