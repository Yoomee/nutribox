module PagesHelper
  
  def page_view_name_input_type(page)
    if !current_user.yoomee_staff? && (page.slug == "blog" || page.descendant_of_slug("blog"))
      :hidden
    else
      :select
    end
  end
  
end