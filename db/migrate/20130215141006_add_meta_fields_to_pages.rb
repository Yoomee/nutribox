class AddMetaFieldsToPages < ActiveRecord::Migration
  def change
    add_column :pages, :title_tag, :text
    add_column :pages, :description_tag, :text
  end
end
