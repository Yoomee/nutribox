class User < ActiveRecord::Base
  include YmUsers::User
  validates_confirmation_of :email
  validates :referral_code, :uniqueness => true
  
  has_many :orders
  has_many :deliveries, :through => :orders
  has_many :referrals, :foreign_key => :referrer_id
  
  before_create :generate_referral_code
  after_create  :record_referral
  
  attr_accessor :referrer_code
  
  def referrals_since_last_delivery
    case deliveries.count
    when 0
      referrals
    when 1
      referrals.where("referrals.created_at > ?", deliveries.first.created_at)
    else
      last_two_deliveries = deliveries.joins(:shipping_date).order(:shipping_date => :created_at).last(2)
      referrals.where("referrals.created_at > ? AND referrals.created_at <= ?", last_two_deliveries.first.created_at, last_two_deliveries.last.created_at)
    end
  end
  
  private
  def generate_referral_code
    begin
      self.referral_code = SecureRandom.urlsafe_base64(4).tr("-_",SecureRandom.hex(1)).upcase
      valid?
    end while errors[:referral_code].present?
  end
  
  def record_referral
    if referrer_code.present? && referrer = User.find_by_referral_code(referrer_code)
      referrer.referrals.create(:referree => self)
    end
  end
  
end