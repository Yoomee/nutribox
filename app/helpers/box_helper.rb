module BoxHelper
  
  def month_name(month_num)
    Date::MONTHNAMES[month_num.to_i]
  end
  
  def box_type_name(box_type)
    names = {'standard' => "Nutribox", 'mini' => "Nutribox-Mini"}
    names[box_type]
  end

end