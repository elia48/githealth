class DailyPlansController < ApplicationController
  def index
    @daily_plans = DailyPlan.all
  end

  def show
    @daily_plan = DailyPlan.find(params[:id])
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

    if @daily_plan.update(check_in_params)
      redirect_to daily_plan_path(@daily_plan),
      notice: "Daily check-in completed!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def ai_answer
    
  end

  private

  def check_in_params
    params.require(:daily_plan).permit(:actual_sleep, :actual_workout_duration, :actual_workout_type, :actual_nutrition, :workout_feeling)
  end

  def daily_plan_params
    params.require(:daily_plans).permit(:planned_sleep, :planned_workout_duration,:planned_workout_type, :planned_nutrition_log)
  end
end
