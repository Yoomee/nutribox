class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name
      t.text :description
      t.text :nutritional_information
      t.string :image_uid
      t.integer :month
      t.integer :year
      t.string :box_type

      t.timestamps
    end
  end
end
