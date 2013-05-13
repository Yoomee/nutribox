class AvailableOrderOption < ActiveRecord::Base
  has_many :order_options
  has_many :orders, :through => :order_options

  validates :option, :presence => true

  def to_s
    option
  end
end
