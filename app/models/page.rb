class Page < ActiveRecord::Base
  include YmCms::Page
  
  def self.view_names
    %w{basic tiled list how_it_works blog blog_post join_gift}
  end
  
end