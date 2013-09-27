class AddOptionIdToDeliveries < ActiveRecord::Migration
  def change
    add_column :deliveries, :option_id, :integer, :after => :box_type
    Delivery.reset_column_information
    Delivery.all.each do |delivery|
      if delivery.order.options.present?
        delivery.update_attributes(:option_id => delivery.order.options.first.id)
      end
    end
  end
end
