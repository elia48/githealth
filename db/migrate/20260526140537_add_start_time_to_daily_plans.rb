class AddStartTimeToDailyPlans < ActiveRecord::Migration[8.1]
  def change
    add_column :daily_plans, :start_time, :datetime
  end
end
