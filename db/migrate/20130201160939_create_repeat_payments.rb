class CreateRepeatPayments < ActiveRecord::Migration
  def change
    create_table :repeat_payments do |t|
      t.belongs_to :order
      t.integer :amount_in_pence
      t.string :vps_transaction_id
      t.string :security_key
      t.string :transaction_auth_number
      t.string :xero_id
      t.string :xero_status, :default => "pending"
      t.timestamps
    end
  end
end
