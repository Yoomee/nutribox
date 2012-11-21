class ApplicationController < ActionController::Base
  include YmUsers::ApplicationController
  
  protect_from_forgery

  before_filter :redirect_if_www
  before_filter :authenticate
  
  AUTH_USERS = { "nutribox" => "nutribox123" }

  private
  def authenticate
    return true unless Rails.env.production?
    authenticate_or_request_with_http_basic do |username|
      AUTH_USERS[username]
    end
  end
  
  def redirect_if_www
    if request.subdomain.present? && request.subdomain == "www"
      redirect_to request.url.sub("www.",'')
    end
  end

end