class ReferralsController < ApplicationController
  load_and_authorize_resource :only => :new
    
  def new
    code = params[:code].upcase
    referrer = User.find_by_referral_code(code)
    if referrer && !current_user
      session[:referral_code] = code
    end
    gift = params[:gift].present?
    @order = Order.new(:gift => gift, :referrer => referrer)
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
    redirect_to root_path unless current_user
    if params[:user_id]
      if current_user.is_admin?
        @user = User.find(params[:user_id])
      else
        redirect_to referrals_path
      end
    else
      if current_user.is_admin?
        @users = User.order('last_name,first_name').joins(:referrals).group("users.id")
        render :action => 'all'
      else
        @user = current_user
      end
    end
  end
  
end