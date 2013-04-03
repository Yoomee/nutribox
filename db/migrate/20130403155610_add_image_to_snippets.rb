class AddImageToSnippets < ActiveRecord::Migration
  def up
    add_column :ym_snippets_snippets, :image_uid, :string, :after => :snippet_type 
    YmSnippets::Snippet.reset_column_information
    YmSnippets::Snippet.create(:slug => :home_page_image, :text => "/gift")
  end
  
  def down
    YmSnippets::Snippet.find_by_slug(:home_page_image).destroy
    remove_column :ym_snippets_snippets, :image_uid
  end
  
end
