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
  
  def downloaded?
    downloaded_mini? && downloaded_standard?
  end
  
  def to_param
    date.strftime("%Y%m%d")
  end
  
  def update_downloaded(box_type)
    case box_type.to_sym
    when :mini
      self.update_attribute(:downloaded_mini,true) unless downloaded_mini?
    when :standard
      self.update_attribute(:downloaded_standard,true) unless downloaded_standard?
    end
  end
  
  private
  def generate_deliveries!
    if week == 4 && !date.five_fridays_in_month?
      weeks = [4, 5]
    else
      weeks = week
    end
    Order.active.alphabetical_by_user.where(:shipping_week => weeks).each do |order|
      self.deliveries.build(:order => order).set_fields_from_order
    end
  end

  def set_week
    self.week = (date - 1.day).shipping_week
  end
  
end