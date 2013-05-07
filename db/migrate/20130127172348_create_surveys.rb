class CreateSurveys < ActiveRecord::Migration
  def change
    create_table :surveys do |t|
      t.integer :delivery_id
      t.timestamps
    end
  end
end
