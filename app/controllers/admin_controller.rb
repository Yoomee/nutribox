class AdminController < ApplicationController
  
  before_filter :get_snippet
  
  def index
    authorize! :admin, :index
  end
  
  def home_page_image
    authorize! :admin, :home_page_image
    if params[:snippet]
      @snippet.update_attributes(params[:snippet])
      flash[:notice] = "Updated home page image."
      redirect_to root_path
    end
  end

  def related_articles
    authorize! :admin, :related_articles
  end
  
  private
  def get_snippet
    @snippet = YmSnippets::Snippet.find_by_slug('home_page_image')
    @snippets = YmSnippets::Snippet.all
  end
  
end