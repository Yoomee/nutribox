class HomeController < ApplicationController
  
  skip_before_filter :authenticate
  
  def index
    @latest_blog_post = Page.find_by_slug("blog").children.latest.first
    render :action => "logged_out_index" unless current_user || Rails.env.development?
  end

end