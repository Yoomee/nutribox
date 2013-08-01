class RelatedLink < ActiveRecord::Base
  belongs_to :page
  image_accessor :image
end
