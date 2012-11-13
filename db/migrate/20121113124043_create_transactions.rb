class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.belongs_to :user
      t.belongs_to :credit_card_details
      t.integer :amount_in_pence
      t.string :vps_transaction_id
      t.string :security_key
      t.string :transaction_auth_number
      t.timestamps
    end
    add_index :transactions, :user_id
  end
end
