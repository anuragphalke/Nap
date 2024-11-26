# rubocop:disable Layout/LineLength
class Routine < ApplicationRecord
  # Associations
  belongs_to :appliance
  has_many :recommendations, dependent: :destroy

  # Validations
  validates :starttime, presence: true, format: { with: /\A([01]?[0-9]|2[0-3]):([0-5][0-9])\z/, message: "must be a valid time in HH:MM format" }
  validates :endtime, presence: true, format: { with: /\A([01]?[0-9]|2[0-3]):([0-5][0-9])\z/, message: "must be a valid time in HH:MM format" }

  # Validates day to be one of the days of the week
  validates :day, presence: true, inclusion: { in: %w[Monday Tuesday Wednesday Thursday Friday Saturday Sunday], message: "%<value>s is not a valid day" }
end
# rubocop:enable Layout/LineLength
