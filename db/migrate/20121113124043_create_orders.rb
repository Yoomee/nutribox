class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.belongs_to :user
      t.belongs_to :delivery_address
      t.integer :amount_in_pence
      t.string  :box_type
      t.integer :number_of_months
      t.string  :billing_name
      t.string  :billing_address1
      t.string  :billing_address2
      t.string  :billing_city
      t.string  :billing_postcode
      t.string  :billing_country
      t.string  :vps_transaction_id
      t.string  :security_key
      t.string  :transaction_auth_number
      t.timestamps
    end
    add_index :orders, :user_id
  end
end
