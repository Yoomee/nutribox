class DeleteSportsNutritionBox < ActiveRecord::Migration
  def up
    old_sports_box = AvailableOrderOption.find_by_name('Sports Nutrition')
    new_sports_box = AvailableOrderOption.find_by_name('The sports performance')
    Order.where(:theme_id => old_sports_box.id).update_all(:theme_id => new_sports_box.id)
    old_sports_box.destroy
  end

  def down
  end
end
