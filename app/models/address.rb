class Address < ActiveRecord::Base
  belongs_to :user
  has_many :orders, :source => :delivery_address
  
  def to_s(separator = ', ')
    [name,address1,address2,city,postcode,country].select(&:present?).join(separator)
  end
end