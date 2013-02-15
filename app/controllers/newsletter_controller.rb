class NewsletterController < ApplicationController
	def subscribe
    uri = URI.parse("http://thenutribox.us6.list-manage1.com/subscribe/post")
    response = Net::HTTP.post_form(uri, params.reverse_merge!(:u => "44bdbc0e5b3036d3b03028268", :id => "f573663757"))
    render :text => response.body.gsub(/http:\/\/thenutribox[^\/]*\/subscribe\/post/, "/newsletter/subscribe")
  end
end