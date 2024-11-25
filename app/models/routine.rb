# rubocop:disable Layout/LineLength
class Routine < ApplicationRecord
  # Associations
  belongs_to :device
  has_many :recommendations, dependent: :destroy

  # Validations
  validates :starttime, presence: true, format: { with: /\A([01]?[0-9]|2[0-3]):([0-5][0-9])\z/, message: "must be a valid time in HH:MM format" }
  validates :endtime, presence: true, format: { with: /\A([01]?[0-9]|2[0-3]):([0-5][0-9])\z/, message: "must be a valid time in HH:MM format" }
  validates :day, presence: true, date: { message: "must be a valid date" }

  # Custom validation to ensure endtime is after starttime
  validate :endtime_after_starttime

  private

  # Custom validation to ensure endtime is after starttime
  def endtime_after_starttime
    return unless starttime.present? && endtime.present? && endtime <= starttime

    errors.add(:endtime, "must be after starttime")
  end
end
# rubocop:enable Layout/LineLength
