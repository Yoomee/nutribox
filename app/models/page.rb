class Page < ActiveRecord::Base
  include YmCms::Page

  has_many :related_links

  has_many :page_connections
  has_many :related_pages, :through => :page_connections, :class_name => 'Page'


  accepts_nested_attributes_for :related_links, :reject_if => :all_blank, :allow_destroy => true
  
  def self.view_names
    %w{basic tiled list how_it_works blog blog_post join_gift special_diets}
  end
  
end