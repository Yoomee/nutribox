class NewsletterController < ApplicationController
  skip_before_filter :force_https_and_remove_www
  
	def subscribe
    if request.method.to_s == "POST"
      redirect_to "http://thenutribox.com/newsletter/subscribe?email=#{params[:email]}"
    else
      uri = URI.parse("http://thenutribox.us6.list-manage1.com/subscribe/post")
      response = Net::HTTP.post_form(uri, {:u => "44bdbc0e5b3036d3b03028268", :id => "f573663757", :EMAIL => params[:email]})
      render :text => response.body
    end
  end
  
end