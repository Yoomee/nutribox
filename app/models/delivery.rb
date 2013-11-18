class Delivery < ActiveRecord::Base
  belongs_to :order, :counter_cache => true
  belongs_to :shipping_date
  belongs_to :option, :class_name => "AvailableOrderOption"
  has_one :survey
  
  delegate :box_name, :theme, :user, :to => :order
  
  validates :order_id, :uniqueness => { :scope => :shipping_date_id }
    
  after_create :set_survey_hash

  attr_accessor :repeat_payment_error_message

  def self.by_month_and_year(month, year)
    where("MONTH(shipping_dates.date) = ? AND YEAR(shipping_dates.date) = ?", month, year).joins(:shipping_date)
  end
  
  def send_email
    UserMailer.survey_invite(self).deliver
  end
  handle_asynchronously :send_email
    
  def set_fields_from_order
    if order
      self.box_type ||= order.box_type
      self.number_of_months ||= order.number_of_deliveries_paid_for_each_billing
      self.gift ||= order.gift
      self.name ||= order.delivery_name
      self.address1 ||= order.delivery_address1
      self.address2 ||= order.delivery_address2
      self.city ||= order.delivery_city
      self.postcode ||= order.delivery_postcode
      self.country ||= order.delivery_country
    end
    self
  end
  
  def address(separator = ', ')
    [name,address1,address2,city,postcode].select(&:present?).join(separator)
  end

  def find_or_create_survey
    survey = Survey.new(:delivery_id => id) if (survey=Survey.find_by_delivery_id(id)).nil?
    survey.save 
    survey    
  end

  def in_current_month?
    created_at.year == Date.today.year && created_at.month == Date.today.month
  end
  
  def paid_for?
    if gift?
      true
    elsif (order.created_at > (shipping_date.date - 1.month)) || (shipping_date == ShippingDate.first)
      true
    elsif order.number_of_deliveries_paid_for >= order.deliveries_count
      true
    elsif order.repeat_payments.with_transaction_auth_number.exists?(["YEAR(created_at) = ? AND MONTH(created_at) = ?",created_at.year,created_at.month])
      true
    else
      false
    end
  end
  
  def month
    shipping_date.date.month
  end

  def repeat_repeat_payment!
    if in_current_month? && failed = order.repeat_payments.without_transaction_auth_number.where(["YEAR(created_at) = ? AND MONTH(created_at) = ?", created_at.year, created_at.month]).first
      failed.destroy
      repeat = order.take_repeat_payment!
      self.repeat_payment_error_message = repeat.errors[:vps_transaction_id]
      repeat.transaction_auth_number.present?
    end
  end

  def tx_code
    if repeat_payment = order.repeat_payments.with_transaction_auth_number.where(["YEAR(created_at) = ? AND MONTH(created_at) = ?", self.created_at.year, self.created_at.month]).first
      "NBR#{repeat_payment.id}"
    else
      "NB#{order.id}"
    end
  end

  def year
    shipping_date.date.year
  end
  
  def survey_percentage_complete
    a = survey.answers.count
    b = Box.new(year,month,box_type).products.count
    (a.to_f / b.to_f * 100.0).to_i
  end
  
  private 
  def set_survey_hash
    self.update_attribute(:survey_hash,Digest::SHA1.hexdigest("#{id}/#{name}"))
  end
  
end