class CreateDiscountCodes < ActiveRecord::Migration
  def change
    create_table :discount_codes do |t|
      t.string :code
      t.integer :percentage
      t.integer :number_available
      t.boolean :expired, :default => false
      t.timestamps
    end
    add_column :orders, :discount_code, :string, :after => :amount_in_pence
  end
end
