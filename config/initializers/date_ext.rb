class Date

  def shipping_week
    next_thursday = self + ((4 - wday) % 7)
    shipping_week = next_thursday.day / 7 + 1
    shipping_week = five_fridays_in_month? ? 5 : 1 if shipping_week == 5
    shipping_week
  end

  def five_fridays_in_month?
    fridays = (beginning_of_month..end_of_month).to_enum.select { |day| day.wday == 5 }
    fridays.size == 5
  end
  
end