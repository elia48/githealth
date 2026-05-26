class CreateDailyPlans < ActiveRecord::Migration[8.1]
  def change
    create_table :daily_plans do |t|
      t.integer :planned_sleep
      t.integer :planned_workout_duration
      t.string :workout_feeling
      t.string :planned_workout_type
      t.text :planned_nutrition_log
      t.integer :actual_sleep
      t.integer :actual_workout_duration
      t.string :actual_workout_type
      t.text :actual_nutrition
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
