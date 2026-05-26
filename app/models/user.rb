class User < ApplicationRecord
  has_many :daily_plans, dependent: :destroy
  has_many :messages

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
end
