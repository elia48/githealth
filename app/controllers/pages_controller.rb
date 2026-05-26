class PagesController < ApplicationController
  def home
    @daily_plan = DailyPlan.find_by(user: current_user)
  end
end
