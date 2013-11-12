module OrdersHelper
  
  def discount_code_class(order)
    if order.discount_code_code.present? && order.discount_code != DiscountCode.default
      if order.discount_code && order.discount_code.available_to?(current_user)
        "success"
      else
        "error"
      end
    else
      ""
    end
  end
  
  def discount_code_label(order)
    if order.discount_code_code.present? && order.discount_code != DiscountCode.default
      if order.discount_code
        if order.discount_code.available_to?(current_user)
          "Your #{order.discount_code.percentage}% discount has been applied"
        else
          "Sorry, that code is no longer available"
        end
      else
        "Sorry, that isn't a valid discount code"
      end
    else
      "Enter your discount code or referral code"
    end
  end
  
  
  def gift_or_join_path(order)
    if order.gift?
      order.new_record? ? gift_path : update_gift_path(order)
    else
      order.new_record? ? join_path : update_join_path(order)
    end
  end
  
end