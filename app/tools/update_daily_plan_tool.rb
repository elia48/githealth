class UpdateDailyPlanTool < RubyLLM::Tool
  description "Updates the current user's daily plan after the user confirms the AI suggestion."

  param :planned_sleep, desc: "Number of hours the user plans to sleep"
  param :planned_workout_duration, desc: "Duration of the planned workout in minutes"
  param :planned_workout_type, desc: "Type of the planned workout (e.g., cardio, strength training, yoga)"
  param :planned_nutrition_log,
        desc: "Description of the planned nutrition for the day (e.g., high protein, low carb, vegetarian)"

  def initialize(daily_plan)
    @daily_plan = daily_plan
  end

  def execute(planned_sleep:, planned_workout_duration:, planned_workout_type:, planned_nutrition_log:)
    last_ai_message = @daily_plan.messages.where(role: "assistant").last


    @daily_plan.update!(
      planned_sleep: planned_sleep,
      planned_workout_duration: planned_workout_duration,
      planned_workout_type: planned_workout_type,
      planned_nutrition_log: planned_nutrition_log
    )

    { status: "updated" }
  end
end
