class OrderMailer < ActionMailer::Base

  helper YmCore::UrlHelper

  default :from => "\"James Thompson\" <james@inplaceofwar.net>",
          :bcc => ["developers@yoomee.com", "andy@yoomee.com"]
  
  def confirmation_email(order)
    @order = order
    @user = order.user
    mail(:to => @user.email, :subject => "The Nutribox - Order confirmation")
  end

end