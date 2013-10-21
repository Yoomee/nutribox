class CorrectTheme < ActiveRecord::Migration
  def up
    Order.where(:theme_id => 2).update_all(:theme_id => AvailableOrderOption.find_by_name('The classic').id)
  end

  def down
  end
end
