class AddThemeIdToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :theme_id, :integer
    Order.reset_column_information
    OrderOption.all.each do |order_option|
      order_option.order.update_attribute(:theme_id, order_option.available_order_option_id)
    end
    Order.where(:theme_id => nil).update_all(:theme_id => 2)
  end
end
