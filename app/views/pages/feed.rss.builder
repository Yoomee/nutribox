xml.instruct! :xml, :version => "1.0" 
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "The Nutribox Blog"
    xml.description "The Nutribox Blog"
    xml.link "#{Settings.site_url}#{page_path(@page)}"
    @page.children.latest.each do |page|
      xml.item do
        xml.title page.title
        xml.description page.text.gsub(/(<img[^>]src=['"])\//){"#{$1}#{Settings.site_url}/"}
        xml.pubDate page.publication_date.strftime("%a, %d %b %G %H:%M:%S GMT")
        xml.link "#{Settings.site_url}#{page_path(page)}"
        xml.guid "#{Settings.site_url}#{page_path(page)}"
      end
    end
  end
end