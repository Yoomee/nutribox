class HomeController < ApplicationController
  
  skip_before_filter :authenticate
  
  def index
    @latest_blog_post = Page.find_by_slug("blog").children.latest.first
    @custom_page_title = YmSnippets::Snippet.find_by_slug('meta_home_page_title')
    @custom_page_description = YmSnippets::Snippet.find_by_slug('meta_home_page_description')
    @custom_page_keywords = YmSnippets::Snippet.find_by_slug('meta_home_page_keywords')
    @home_page_image = YmSnippets::Snippet.find_by_slug('home_page_image')
    #render :action => "logged_out_index" unless current_user || Rails.env.development?
  end

end