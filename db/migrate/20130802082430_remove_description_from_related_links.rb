class RemoveDescriptionFromRelatedLinks < ActiveRecord::Migration
  def up
    remove_column :related_links, :description
  end

  def down
    add_column :related_links, :description, :string
  end
end
