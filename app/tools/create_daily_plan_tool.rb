class CreateDailyPlanTool < RubyLLM::Tool
  description "Creates a daily plan based on the log the user is giving you."
  param :planned_sleep, desc: "Number of hours the user plans to sleep"
  param :planned_workout_duration, desc: "Duration of the planned workout in minutes"
  param :planned_workout_type, desc: "Type of the planned workout (e.g., cardio, strength training, yoga)"
  param :planned_nutrition_log,
        desc: "Description of the planned nutrition for the day (e.g., high protein, low carb, vegetarian)"

  def initialize(user:)
    @user = user
  end

  def execute(planned_sleep:, planned_workout_duration:, planned_workout_type:, planned_nutrition_log:)
    DailyPlan.create(
      user: @user,
      planned_sleep: planned_sleep,
      planned_workout_duration: planned_workout_duration,
      planned_workout_type: planned_workout_type,
      planned_nutrition_log: planned_nutrition_log
    )

    { status: "created" }
  end
end
