class ApplicationController < ActionController::Base
  include YmUsers::ApplicationController
  
  protect_from_forgery

  before_filter :authenticate
  
  AUTH_USERS = { "nutribox" => "nutribox123" }
  
  def after_sign_in_path_for_resource(user)
    orders_path
  end

  private
  def authenticate
    return true unless Rails.env.production?
    authenticate_or_request_with_http_basic do |username|
      AUTH_USERS[username]
    end
  end

end