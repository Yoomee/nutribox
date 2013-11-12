class YmSnippets::Snippet < ActiveRecord::Base

  image_accessor :image

  self.table_name = "ym_snippets_snippets"
  
  validates :slug, :presence => true

  def use_redactor?
  	slug == 'home_page_more_text' || slug == 'order_first_page_intro_text' || slug == 'order_first_page_intro_text_gift'
  end

  def to_s
    text
  end
  
end