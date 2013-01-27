class CreateSurveys < ActiveRecord::Migration
  def change
    create_table :surveys do |t|
      t.string :hash
      t.string :email
      t.integer :delivery_id
      t.integer :month
      t.integer :year
      t.string :box_type

      t.timestamps
    end
  end
end
