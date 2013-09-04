class DeleteSportsNutritionBox < ActiveRecord::Migration
  def up
  	AvailableOrderOption.find_by_name('Sports Nutrition').destroy
  end

  def down
  end
end
