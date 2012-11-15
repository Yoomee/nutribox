class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.belongs_to :user
      t.string :name
      t.string :address1
      t.string :address2
      t.string :city
      t.string :postcode
      t.string :country
      t.timestamps
    end
    add_index :addresses, :user_id
  end
end
