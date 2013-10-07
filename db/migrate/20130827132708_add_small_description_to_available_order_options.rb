class AddSmallDescriptionToAvailableOrderOptions < ActiveRecord::Migration
  def change
    add_column :available_order_options, :small_description, :text, :after => :description
  end
end
