class NewsletterController < ApplicationController
  skip_before_filter :force_https_and_remove_www
  
	def subscribe
    if request.method.to_s == "POST"
      redirect_to subscribe_newsletter_path(:email => params[:email]), :protocol => "http://"
    else
      uri = URI.parse("http://thenutribox.us6.list-manage1.com/subscribe/post")
      response = Net::HTTP.post_form(uri, {:u => "44bdbc0e5b3036d3b03028268", :id => "f573663757", :EMAIL => params[:email]})
      render :text => response.body
    end
  end
  
end