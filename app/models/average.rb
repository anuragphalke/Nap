# rubocop:disable Layout/LineLength
class Average < ApplicationRecord
  # Associations
  belongs_to :price

  # Validations
  validates :day, presence: true, inclusion: { in: %w[Monday Tuesday Wednesday Thursday Friday Saturday Sunday], message: "%<value>s is not a valid day" }
  validates :time, presence: true
  validates :average, presence: true
end
# rubocop:enable Layout/LineLength
