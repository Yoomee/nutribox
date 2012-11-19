class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.belongs_to :user
      t.integer :amount_in_pence
      t.string  :box_type
      t.integer :number_of_months
      t.boolean :gift, :default => false
      t.string  :vps_transaction_id
      t.string  :security_key
      t.string  :transaction_auth_number
      t.string  :delivery_name
      t.string  :delivery_address1
      t.string  :delivery_address2
      t.string  :delivery_city
      t.string  :delivery_postcode
      t.string  :delivery_country
      t.string  :billing_name
      t.string  :billing_address1
      t.string  :billing_address2
      t.string  :billing_city
      t.string  :billing_postcode
      t.string  :billing_country
      t.timestamps
    end
    add_index :orders, :user_id
  end
end
