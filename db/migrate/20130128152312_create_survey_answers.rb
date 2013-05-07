class CreateSurveyAnswers < ActiveRecord::Migration
  def change
    create_table :survey_answers do |t|
      t.integer :survey_id
      t.integer :product_id
      t.integer :rating
      t.text :comment

      t.timestamps
    end
  end
end
