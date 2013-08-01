class CreatePageConnections < ActiveRecord::Migration
  def change
    create_table :page_connections do |t|
      t.references :page
      t.references :related_page

      t.timestamps
    end
    add_index :page_connections, :page_id
    add_index :page_connections, :related_page_id
  end
end
