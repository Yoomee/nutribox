class ShippingDate < ActiveRecord::Base
  include YmCore::Model
  
  has_many :deliveries, :autosave => true
  validates :date, :presence => true, :uniqueness => true
  
  before_create :generate_deliveries!
  
  def self.find_by_param(param)
    find_by_date(Date.parse(param))
  end
  
  def to_param
    date.strftime("%Y%m%d")
  end
  
  private
  def generate_deliveries!
    Order.active.alphabetical_by_user.each do |order|
      self.deliveries.build(:order => order).set_fields_from_order
    end
  end
  
end