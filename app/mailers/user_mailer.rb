class UserMailer < ActionMailer::Base
  
  helper YmCore::UrlHelper

  default :from => "\"The Nutribox\" <emma@thenutribox.com>",
          :bcc => ["developers@yoomee.com"]
          
  def survey_invite(delivery)
    @user = delivery.order.user
    @delivery = delivery
    mail(:to => @user.email, :subject => "What did you think about #{Date::MONTHNAMES[delivery.month]}'s box?")
  end
          
end
