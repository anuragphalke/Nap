# rubocop:disable Layout/LineLength
class Average < ApplicationRecord

  # Validations
  validates :day, presence: true, inclusion: { in: ["1", "2", "3", "4", "5", "6", "7"], message: "%<value>s is not a valid day" }
  validates :time, presence: true
  validates :average, presence: true
end
# rubocop:enable Layout/LineLength
