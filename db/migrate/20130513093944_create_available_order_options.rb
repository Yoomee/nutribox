class CreateAvailableOrderOptions < ActiveRecord::Migration
  def change
    create_table :available_order_options do |t|
      t.string :option

      t.timestamps
    end
    AvailableOrderOption.reset_column_information
    AvailableOrderOption.create(:option => 'vegan')
  end
end
