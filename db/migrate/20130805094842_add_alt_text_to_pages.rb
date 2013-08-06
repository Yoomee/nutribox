class AddAltTextToPages < ActiveRecord::Migration
  def change
    add_column :pages, :alt_text, :string
  end
end
