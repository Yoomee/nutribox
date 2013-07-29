module ShareHelper
  def facebook_share_link(url, options = {})
    options[:text] ||= "Share on Facebook"
    share_params = {
      :app_id => "443658312367297",
      :link => url,
      :redirect_uri => request.url,
      :name => options[:share_name],
      :description => options[:share_description],
      :picture => options[:share_picture]
    }
    link_to("<icon class='icon-facebook'></icon> #{options[:text]}".html_safe, "https://www.facebook.com/dialog/feed?#{share_params.to_query}", :rel => "nofollow", :target => "_blank", :class => 'btn share-link facebook-share-link')
  end
  
  
  def twitter_share_link(url, options)
    options[:text] ||= "Share on Twitter"
    share_params = {
      :url => url,
      :text => options[:share_text],
      :via => "thenutribox",
      :related => "thenutribox"
    }
    link_to("<icon class='icon-twitter'></icon> #{options[:text]}".html_safe, "https://twitter.com/intent/tweet?#{share_params.to_query}", :rel => "nofollow", :target => "_blank",  :class => 'btn share-link twitter-share-link')
  end
  
  
  def twitter_share_button(resource,options={})
    options.reverse_merge!({
      :link_text => "Tweet",
      :count => "horizontal",
      :url => "#{Settings.site_url + url_for(resource)}",
      :text => resource.to_s
    })
    options[:class] = "twitter-share-button #{options[:class]}".strip
    "".tap do |out|
      out << link_to(options[:link_text], "http://twitter.com/share", :rel => "nofollow", :class=>"twitter-share-button", :data => options.slice(:count, :url, :text, :via, :related))
      unless @included_twitter_widgets_js
        out << javascript_include_tag('https://platform.twitter.com/widgets.js')
        @included_twitter_widgets_js = true
      end
    end.html_safe
  end

  def facebook_like_button(resource)
    url_options = {
      :send => false,
      :layout => 'button_count',
      :width => 90,
      :show_faces => false,
      :action => 'like',
      :colorscheme => 'light',
      :height => 20,
      :appId => Settings.facebook_app_id
    }
    content_tag(:iframe, '', :src => "//www.facebook.com/plugins/like.php?href=#{Settings.site_url + url_for(resource)}&#{url_options.to_query}", :rel => "nofollow", :scrolling => "no", :frameborder => "0", :allowTransparency => true, :style => "border:none; overflow:hidden; width:90px; height:20px;")
  end
end

def pinterest_pin_button(resource)
    url_options = {
      :url => Settings.site_url + url_for(resource),
      :media => resource.image ? Settings.site_url + resource.image.url : nil,     
      :description => resource.to_s
    }

    link_to "//pinterest.com/pin/create/button/?#{url_options.to_query}", :rel => "nofollow", :"data-pin-do" => "buttonPin", :"data-pin-config" => "above"  do
      image_tag("//assets.pinterest.com/images/pidgets/pin_it_button.png")
    end
end
