class RemoveDownloadedAttributesFromShippingDate < ActiveRecord::Migration
  def up
    remove_column :shipping_dates, :downloaded_mini
    remove_column :shipping_dates, :downloaded_standard
  end

  def down
    add_column :shipping_dates, :downloaded_mini, :boolean
    add_column :shipping_dates, :downloaded_standard, :boolean
  end
end
