class Delivery < ActiveRecord::Base
  belongs_to :order
  belongs_to :shipping_date
  
  delegate :user, :to => :order
  
  validates :order_id, :uniqueness => { :scope => :shipping_date_id }
    
  def set_fields_from_order
    if order
      self.box_type ||= order.box_type
      self.number_of_months ||= order.number_of_months
      self.gift ||= order.gift
      self.name ||= order.delivery_name
      self.address1 ||= order.delivery_address1
      self.address2 ||= order.delivery_address2
      self.city ||= order.delivery_city
      self.postcode ||= order.delivery_postcode
      self.country ||= order.delivery_country
      self.notes ||= order.delivery_notes
    end
    self
  end
  
  def address(separator = ', ')
    [name,address1,address2,city,postcode].select(&:present?).join(separator)
  end
  
end