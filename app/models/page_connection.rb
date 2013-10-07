class PageConnection < ActiveRecord::Base
  belongs_to :page
  belongs_to :related_page, :class_name => 'Page'
end
