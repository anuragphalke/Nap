# rubocop:disable Layout/LineLength
class Average < ApplicationRecord
  # Associations
  belongs_to :price

  # Validations
  validates :day, presence: true, date: { message: "must be a valid date" }
  validates :time, presence: true, format: { with: /\A([01]?[0-9]|2[0-3]):([0-5][0-9])\z/, message: "must be a valid time in HH:MM format" }
  validates :average, presence: true, numericality: { only_float: true, message: "must be a valid float number" }
end
# rubocop:enable Layout/LineLength
