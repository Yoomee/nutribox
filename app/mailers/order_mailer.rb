class OrderMailer < ActionMailer::Base

  helper YmCore::UrlHelper

  default :from => "\"The Nutribox\" <emma@thenutribox.com>",
          :bcc => ["developers@yoomee.com", "andy@yoomee.com"]
  
  def change_frequency_email(order, frequency_changes)
    @order = order
    @user = order.user
    @frequency_changes = frequency_changes
    mail(:to => Settings.site_email, :subject => "The Nutribox - Order frequency changed")
  end

  def change_status_email(order, status_changes)
    @order = order
    @user = order.user
    @status_changes = status_changes
    mail(:to => Settings.site_email, :subject => "The Nutribox - Order status changed")
  end

  def confirmation_email(order)
    @order = order
    @user = order.user
    mail(:to => @user.email, :subject => "The Nutribox - Order confirmation")
  end

end