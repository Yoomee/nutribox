class PagesController < ApplicationController
  include YmCms::PagesController
  
  def new
    set_user
    @page.publication_date = Date.today
    @page.parent = Page.find_by_id(params[:parent])
    if @page.parent.try(:slug) == "blog"
      @page.view_name = "blog_post"
    end
  end
end