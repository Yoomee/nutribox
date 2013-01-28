class Survey < ActiveRecord::Base
    
  include CanCan::Ability
  belongs_to :delivery
  
  has_many :answers, :class_name => "SurveyAnswer"
  
  def month
    delivery.shipping_date.date.month
  end
  
  def year
    delivery.shipping_date.date.year
  end
  
  def box_type
    delivery.box_type
  end
  
  def box
    @box ||= Box.new(year, month, box_type)
  end
  
  def answer_for_product(product)
    answers.where(:product_id => product.id).try(:first)
  end
  
end
