class AvailableOrderOption < ActiveRecord::Base

  include YmCore::Model

  has_many :order_options
  has_many :orders, :through => :order_options

  amount_accessor :mini_price_for_one_delivery, :standard_price_for_one_delivery, :mini_price_for_three_deliveries
  amount_accessor :standard_price_for_three_deliveries, :mini_price_for_six_deliveries, :standard_price_for_six_deliveries
  image_accessor :image

  validates :description, :image, :name, :presence => true
  validates :mini_price_for_one_delivery, :standard_price_for_one_delivery, :mini_price_for_three_deliveries, :presence => true
  validates :standard_price_for_three_deliveries, :mini_price_for_six_deliveries, :standard_price_for_six_deliveries, :presence => true

  def cost(box_type, number_of_deliveries_paid_for_each_billing)
    YmCore::Model::AmountAccessor::Float.new((self.cost_in_pence(box_type, number_of_deliveries_paid_for_each_billing).to_f / 100).round(2))
  end

  def cost_in_pence(box_type, number_of_deliveries_paid_for_each_billing)
    case number_of_deliveries_paid_for_each_billing
    when 1
      box_type == 'mini' ? mini_price_for_one_delivery_in_pence : standard_price_for_one_delivery_in_pence
    when 3
      box_type == 'mini' ? (mini_price_for_three_deliveries_in_pence * 3) : (standard_price_for_three_deliveries_in_pence * 3)
    when 6
      box_type == 'mini' ? (mini_price_for_six_deliveries_in_pence * 6) : (standard_price_for_six_deliveries_in_pence * 6)
    end
  end

  def filename
    name.gsub(' ', '-').downcase
  end

  def to_s
    name
  end

end
