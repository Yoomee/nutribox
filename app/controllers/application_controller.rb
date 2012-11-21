class ApplicationController < ActionController::Base
  include YmUsers::ApplicationController
  
  protect_from_forgery

  prepend_before_filter :force_https_and_remove_www
  before_filter :authenticate
  
  AUTH_USERS = { "nutribox" => "nutribox123" }

  private
  def authenticate
    return true unless Rails.env.production?
    authenticate_or_request_with_http_basic do |username|
      AUTH_USERS[username]
    end
  end
  
  def force_https_and_remove_www
    if Rails.env.production? && (!request.ssl? || (request.subdomain.to_s == "www"))
      redirect_options = {
        :protocol => 'https://',
        :host => request.host.sub('www.',''),
        :status => :moved_permanently,
        :params => request.query_parameters
      }
      redirect_to redirect_options
    end
  end

end