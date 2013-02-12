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
    return false unless @page && @page.slug
    @page.slug.to_sym == slug || @page.descendant_of_slug(slug)
  end
  
  def google_analytics_js_with_ecommerce
    tracker_code = "asdasdad"#Settings.google_analytics
    if true #!(Rails.env =~ /development|test/) && (tracker_code = Settings.google_analytics).present?
      analytics_js = <<-JS
        var _gaq = _gaq || [];
        _gaq.push(['_setAccount', '#{tracker_code}']);
        _gaq.push(['_trackPageview']);
      JS
      
      if @order && controller_name.orders? && action_name.thanks?
        analytics_js << <<-JS
        _gaq.push(['_addTrans',
          '#{@order.order_number}',   // transaction ID - required
          'The Nutribox',             // affiliation or store name
          '#{@order.amount}',         // total - required
          '#{@order.vat}',            // tax
          '',                         // shipping
          '#{@order.billing_city}',   // city
          '',                         // state or province
          '#{@order.billing_country}' // country
        ]);

        _gaq.push(['_addItem',
          '#{@order.order_number}',   // transaction ID - required
          '#{@order.sku}',            // SKU/code - required
          '#{@order.product}',        // product name
          '',                         // category or variation
          '#{@order.amount}',         // unit price - required
          '1'                         // quantity - required
        ]);
        _gaq.push(['_trackTrans']);
        JS
      end
      
      analytics_js << <<-JS
        (function() {
          var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
          ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
          var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
        })();
      JS
      javascript_tag analytics_js.html_safe
    end
  end
  
end
