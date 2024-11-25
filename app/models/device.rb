# rubocop:disable Layout/LineLength
class Device < ApplicationRecord
  # Associations
  belongs_to :user
  has_many :routines, dependent: :destroy

  # Validations
  validates :name, presence: true
  validates :category, presence: true, inclusion: {
    in: ['air conditioner', 'washing machine', 'dishwasher', 'EV Charger', 'boiler/heating', 'TV & Consoles'],
    message: "%<value>s is not a valid category"
  }
end
# rubocop:enable Layout/LineLength
