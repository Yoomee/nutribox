module PagesHelper
  
  def page_view_name_input_type(page)
    if !current_user.yoomee_staff? && (page.slug == "blog" || page.descendant_of_slug("blog"))
      :hidden
    else
      :select
    end
  end
  
  def summary_or_truncated_text(page,length)
    if page.summary.present?
      summary
    else
      strip_tags(page.text).truncate(length)
    end
  end
  
end