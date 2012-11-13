class CreateCreditCardDetails < ActiveRecord::Migration
  def change
    create_table :credit_card_details do |t|
      t.belongs_to :user
      t.string  :name
      t.string  :number
      t.integer :month
      t.integer :year
      t.string  :address1
      t.string  :address2
      t.string  :city
      t.string  :zip
      t.string  :country 
      t.timestamps     
    end
    add_index :credit_card_details, :user_id
  end
end