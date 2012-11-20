class User < ActiveRecord::Base
  include YmUsers::User
  validates_confirmation_of :email
  
  has_many :orders
  
end