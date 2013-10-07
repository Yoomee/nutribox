class ReferralsController < ApplicationController
  load_and_authorize_resource
    
  def new
    code = params[:code].upcase
    if User.exists?(:referral_code => code) && !current_user
      session[:referral_code] = code
    end
        gift = params[:gift].present?
    @order = Order.new(:gift => gift)
    @themes = AvailableOrderOption.order(:position)
    if gift
      @custom_page_title = YmSnippets::Snippet.find_by_slug('meta_gift_page_title').text
      @custom_page_description = YmSnippets::Snippet.find_by_slug('meta_gift_page_description')
      @custom_page_keywords = YmSnippets::Snippet.find_by_slug('meta_gift_page_keywords')
    else
      @order.discount_code = DiscountCode.default
      @custom_page_title = YmSnippets::Snippet.find_by_slug('meta_join_page_title')
      @custom_page_description = YmSnippets::Snippet.find_by_slug('meta_join_page_description')
      @custom_page_keywords = YmSnippets::Snippet.find_by_slug('meta_join_page_keywords')
    end
    render :template => "orders/new"
  end
  
  def index
  end
  
end