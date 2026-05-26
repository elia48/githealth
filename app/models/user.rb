class User < ApplicationRecord
  has_many :daily_plans, dependent: :destroy

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
end
