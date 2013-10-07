class CreateRelatedLinks < ActiveRecord::Migration
  def change
    create_table :related_links do |t|
      t.string :url
      t.string :title
      t.string :image_uid
      t.text :description
      t.references :page

      t.timestamps
    end
    add_index :related_links, :page_id
  end
end
