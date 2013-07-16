class AvailableOrderOption < ActiveRecord::Base

  include YmCore::Model

  has_many :order_options
  has_many :orders, :through => :order_options

  amount_accessor :mini_price, :standard_price
  image_accessor :image

  validates :description, :image, :mini_price, :name, :standard_price, :presence => true

  def cost_in_pence(box_type)
    box_type == 'mini' ? mini_price_in_pence : standard_price_in_pence
  end

  def to_s
    name
  end

end
