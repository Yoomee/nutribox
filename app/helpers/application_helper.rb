module ApplicationHelper
  
  def launch_countdown
    days = (Date.new(2012,11,30) - Date.today).to_i
    if days > 0
      content_tag(:div, content_tag(:span, "#{pluralize(days, 'day')}"), :id => 'launch-countdown')
    else
      ''
    end
  end
  
  def slug_active?(slug)
    return false unless @page
    @page.slug.to_sym == slug || @page.descendant_of_slug(slug)
  end
  
end
