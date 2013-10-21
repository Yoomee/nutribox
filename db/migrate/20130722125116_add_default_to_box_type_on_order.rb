class AddDefaultToBoxTypeOnOrder < ActiveRecord::Migration
  def change
    change_column_default :orders, :box_type, 'standard'
  end
end
