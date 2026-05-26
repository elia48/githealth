class Message < ApplicationRecord
  belongs_to :daily_plan

  validates :content, presence: true
  validates :role, presence: true
end
