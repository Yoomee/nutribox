class ShippingDate < ActiveRecord::Base
  include YmCore::Model
  
  has_many :deliveries, :autosave => true, :dependent => :destroy
  validates :date, :presence => true, :uniqueness => true
  

  before_validation :set_week
  before_create :generate_deliveries!
  
  class << self
    def find_by_param(param)
      find_by_date(Date.parse(param))
    end
  
    def by_month_and_year(month, year)
      where("MONTH(date) = ? AND YEAR(date) = ?", month, year)
    end
  end

  def to_param
    date.strftime("%Y%m%d")
  end
  
  private
  def generate_deliveries!
    weeks = (week == 4 && !date.five_fridays_in_month?) ? [4, 5] : week

    Order.active.alphabetical_by_user.for_shipping_date_by_weeks(weeks).each do |order|
      most_recent_delivery = order.deliveries.joins(:shipping_date).order("shipping_dates.date DESC").first
      # Only add to shipping list if order isn't in a shipping list from the last 5 days
      # i.e. allow shipping list to be generated on Thursday and Friday without duplication
      unless most_recent_delivery && most_recent_delivery.shipping_date.date > Date.today - 5
        self.deliveries.build(:order => order).set_fields_from_order
      end
    end
  end

  def set_week
    self.week = (date - 1.day).shipping_week
  end
  
end