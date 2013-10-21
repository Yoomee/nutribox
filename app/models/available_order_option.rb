class AvailableOrderOption < ActiveRecord::Base

  include YmCore::Model

  has_many :orders, :foreign_key => 'theme_id'

  amount_accessor :mini_price_for_one_delivery, :standard_price_for_one_delivery
  amount_accessor :mini_price_for_three_deliveries, :standard_price_for_three_deliveries
  amount_accessor :mini_price_for_six_deliveries, :standard_price_for_six_deliveries
  amount_accessor :mini_price_for_twelve_deliveries, :standard_price_for_twelve_deliveries
  amount_accessor :mini_price_for_twelve_deliveries, :standard_price_for_twelve_deliveries
  amount_accessor :mini_price_for_twenty_four_deliveries, :standard_price_for_twenty_four_deliveries
  image_accessor :image

  validates :name, :presence => true
  validates :mini_price_for_one_delivery, :standard_price_for_one_delivery, :presence => true
  validates :mini_price_for_three_deliveries, :standard_price_for_three_deliveries, :presence => true
  validates :mini_price_for_six_deliveries, :standard_price_for_six_deliveries, :presence => true
  validates :mini_price_for_twelve_deliveries, :standard_price_for_twelve_deliveries, :presence => true
  validates :mini_price_for_twenty_four_deliveries, :standard_price_for_twenty_four_deliveries, :presence => true

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
    when 12
      box_type == 'mini' ? (mini_price_for_twelve_deliveries_in_pence * 12) : (standard_price_for_twelve_deliveries_in_pence * 12)
    when 24
      box_type == 'mini' ? (mini_price_for_twenty_four_deliveries_in_pence * 24) : (standard_price_for_twenty_four_deliveries_in_pence * 24)
    end
  end

  def filename
    name.gsub(' ', '-').downcase
  end

  def to_s
    name
  end

end
AvailableOrderOption::DURATIONS = [[1, 'one_delivery'], [3, 'three_deliveries'], [6, 'six_deliveries'], [12, 'twelve_deliveries'], [24, 'twenty_four_deliveries']]
AvailableOrderOption::SIZES = %w{standard mini}