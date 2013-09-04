xml.url do
  xml.loc(Settings.site_url + url_for(page))
end
page.all_children(:published_only => true, :show_hidden => false, :show_expired => false, :latest => true).each do |child|
  if child.is_a?(Page)
    xml.url do
      xml.loc(Settings.site_url + url_for(child))
    end
  else
    xml << render("page", :page => child)
  end
end