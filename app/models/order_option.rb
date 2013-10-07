class OrderOption < ActiveRecord::Base
  belongs_to :order
  belongs_to :available_order_option

  def to_s
    available_order_option.to_s
  end

end
