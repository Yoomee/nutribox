class BoxesController < ApplicationController
  load_and_authorize_resource

  def show
    @box = Box.new(params[:year], params[:month], params[:box_type])
    if !Box.types.include?(@box.type) || @box.type == 'both'
      not_found
    else
      @products = @box.products
      month = Date::MONTHNAMES[params[:month].to_i]
      box_type = params[:box_type].capitalize
      @custom_page_title = "#{month} #{box_type} Box Archive | The Nutribox"
      @custom_page_description = "The Nutribox #{box_type} #{month} - each month your box comes with a variety of snacks. Want to know what deliciously nutritious snacks were in this month's box?"
      @custom_page_keywords = YmSnippets::Snippet.find_by_slug(:meta_box_page_keywords)
    end
  end

  def latest
    redirect_to box_path(:year => Box.latest_year, :month => Box.latest_month, :box_type => 'standard')
  end

end
