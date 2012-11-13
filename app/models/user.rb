class User < ActiveRecord::Base
  include YmUsers::User
  
  has_many :credit_card_details, :class_name => "CreditCardDetails"
  
end