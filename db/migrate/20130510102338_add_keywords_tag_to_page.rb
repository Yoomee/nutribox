class AddKeywordsTagToPage < ActiveRecord::Migration
  def change
    add_column :pages, :keywords_tag, :text
  end
end
