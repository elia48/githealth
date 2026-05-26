class DailyPlan < ApplicationRecord
  belongs_to :user
  has_many :messages, dependent: :destroy

  validates :planned_sleep, presence: true
  validates :planned_workout_duration, presence: true
  validates :planned_workout_type, presence: true
end
