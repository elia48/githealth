
Message.destroy_all
DailyPlan.destroy_all
User.destroy_all

juan = User.create!(
  email: "juan@example.com",
  password: "password123",
  password_confirmation: "password123"
)

alex = User.create!(
  email: "alex@example.com",
  password: "password123",
  password_confirmation: "password123"
)

plan1 = DailyPlan.create!(
  user: juan,
  planned_sleep: 8,
  planned_workout_duration: 60,
  workout_feeling: "Energetic",
  planned_workout_type: "HIIT",
  planned_nutrition_log: "High protein meals and hydration focus",
  actual_sleep: 7,
  actual_workout_duration: 45,
  actual_workout_type: "HIIT",
  actual_nutrition: "Chicken, rice, avocado, protein shake"
)

plan2 = DailyPlan.create!(
  user: alex,
  planned_sleep: 7,
  planned_workout_duration: 45,
  workout_feeling: "Moderate",
  planned_workout_type: "Strength Training",
  planned_nutrition_log: "Low sugar and balanced carbs",
  actual_sleep: 8,
  actual_workout_duration: 50,
  actual_workout_type: "Strength Training",
  actual_nutrition: "Eggs, salmon, quinoa, vegetables"
)

Message.create!(
  daily_plan: plan1,
  role: "assistant",
  content: "Good afternoon! Based on your sleep recovery, today is ideal for a moderate HIIT session."
)

Message.create!(
  daily_plan: plan1,
  role: "user",
  content: "I feel slightly tired today. Should I reduce intensity?"
)

Message.create!(
  daily_plan: plan1,
  role: "assistant",
  content: "Yes. Reducing intensity by 15% may improve recovery and performance tomorrow."
)

Message.create!(
  daily_plan: plan2,
  role: "assistant",
  content: "Your sleep consistency improved this week. Keep prioritizing recovery."
)

# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
