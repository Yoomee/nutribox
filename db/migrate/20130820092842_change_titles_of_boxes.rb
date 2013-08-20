class ChangeTitlesOfBoxes < ActiveRecord::Migration
  def up
  	AvailableOrderOption.find_by_name('The Nutribox').update_attribute(:name, 'The classic')
  	AvailableOrderOption.find_by_name('The Vegan Nutribox').update_attribute(:name, 'The vegan')
  end

  def down
  	AvailableOrderOption.find_by_name('The classic').update_attribute(:name, 'The Nutribox')
  	AvailableOrderOption.find_by_name('The vegan').update_attribute(:name, 'The Vegan Nutribox')
  end
end
