class AddXeroIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :xero_id, :string
  end
end
