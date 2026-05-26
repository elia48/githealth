class AddDateToDailyPlans < ActiveRecord::Migration[8.1]
  def change
    add_column :daily_plans, :date, :date
  end
end
