class User < ActiveRecord::Base
  include YmUsers::User
  
  has_many :orders
  has_many :addresses
  
end