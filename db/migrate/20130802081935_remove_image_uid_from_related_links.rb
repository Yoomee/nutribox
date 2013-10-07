class RemoveImageUidFromRelatedLinks < ActiveRecord::Migration
  def up
    remove_column :related_links, :image_uid
  end

  def down
    add_column :related_links, :image_uid, :string
  end
end
