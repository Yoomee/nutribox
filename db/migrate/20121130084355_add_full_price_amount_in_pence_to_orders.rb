class AddFullPriceAmountInPenceToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :full_price_amount_in_pence, :integer, :after => :amount_in_pence
  end
end
