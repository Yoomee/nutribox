class PagesController < ApplicationController
  include YmCms::PagesController

  # def edit
  #   @blog_posts = [*Page.find_by_parent_id(4)]
  #   @page = Page.
  # end
  
  def feed
    @page = Page.find_by_slug('blog')
  end
  
  def show
    if @page.title_tag
      @custom_page_title = @page.title_tag
    else
      @custom_page_title = "#{Settings.site_name} #{@page.title}"
    end
    @related_blog_posts = PageConnection.where(:page_id => @page.id)
    @related_external_links = RelatedLink.where(:page_id => @page.id)
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

  def index
    respond_to do |format|
      format.html
      format.xml # index.xml.builder
    end    
  end
end