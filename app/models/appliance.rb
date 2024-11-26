class Appliance < ApplicationRecord
  # Associations
  belongs_to :user
  has_many :routines, dependent: :destroy

  # Validations
  validates :name, presence: true
  validates :category, presence: true, inclusion: { in: [
    'air conditioner', 'washing machine', 'dishwasher', 'EV Charger', 'boiler/heating', 'TV & Consoles'
  ] }
  validates :wattage, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
