class CreateShippingDatesAndDeliveries < ActiveRecord::Migration
  def change
    create_table :shipping_dates do |t|
      t.date :date
      t.boolean :downloaded, :default => false
      t.timestamps
    end
    create_table :deliveries do |t|
      t.belongs_to :order
      t.belongs_to :shipping_date
      t.string :box_type
      t.string :name
      t.string :address1
      t.string :address2
      t.string :city
      t.string :postcode
      t.string :country
      t.text   :notes
      t.timestamps
    end
    add_index :deliveries, :order_id 
    add_index :deliveries, :shipping_date_id
  end
end
