xml.instruct!
xml.urlset :xmlns => "http://www.sitemaps.org/schemas/sitemap/0.9", "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance" do
  @pages.each do |page|
    xml << render("page", :page => page)
  end
  
  xml.url do
    xml.loc(Settings.site_url + url_for(join_path))
  end

  xml.url do
    xml.loc(Settings.site_url + url_for(gift_path))
  end

  xml.url do
    xml.loc(Settings.site_url + url_for(latest_box_path))
  end
end