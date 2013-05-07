class PagesController < ApplicationController
  include YmCms::PagesController
  
  def feed
    @page = Page.find_by_slug('blog')
  end
  
  def show
    if @page.title_tag
      @custom_page_title = @page.title_tag
    else
      @custom_page_title = "#{Settings.site_name} #{@page.title}"
    end
    super
  end
  
  def new
    set_user
    @page.publication_date = Date.today
    @page.parent = Page.find_by_id(params[:parent])
    if @page.parent.try(:slug) == "blog"
      @page.view_name = "blog_post"
    end
  end
end