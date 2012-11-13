class Page < ActiveRecord::Base
  include YmCms::Page
  
  def self.view_names
    %w{basic tiled list}
  end
  
end