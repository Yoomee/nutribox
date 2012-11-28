class AddEncryptedCreditCardNumberToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :encrypted_credit_card_number, :string, :after => :gift
    #add_column :orders, :credit_card_number_tail, :string, :after => :gift
  end
end
