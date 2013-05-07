class AddSurveyHashToDeliveries < ActiveRecord::Migration
  def up
    add_column :deliveries, :survey_hash, :string

    Delivery.reset_column_information
    Delivery.find_each do |delivery|
      delivery.save
    end

  end
  
  def down
    remove_column :deliveries, :survey_hash
  end
  
end
