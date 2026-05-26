class DailyPlansController < ApplicationController
  def index
    @daily_plans = DailyPlan.all
  end

  def new
    @daily_plan = DailyPlan.new
  end

  def create
    @daily_plan = DailyPlan.new(daily_plan_params)
    @daily_plan.save
  end

  def edit
    @daily_plan = DailyPlan.find(params[:id])
  end

  def update
    @daily_plan = DailyPlan.find(params[:id])
    @daily_plan.update(params[:daily_plan])
  end

  private

  def daily_plan_params
    params.require(:daily_plans).permit(:planned_sleep, :planned_workout_duration,:planned_workout_type, :planned_nutrition_log)
  end
end
