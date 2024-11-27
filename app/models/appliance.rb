class Appliance < ApplicationRecord
  # Associations
  belongs_to :user
  has_many :routines, dependent: :destroy

  # Validations
  validates :name, presence: true
  # validates :category, presence: true, inclusion: { in: [
  #   'air conditioning', 'washing machine', 'dishwasher', 'EV Charger', 'heating', 'TV & Consoles'
  # ] }
  validates :category, presence: true, inclusion: { in: [
    'kitchen', 'EV Charger', 'climate control', 'entertainment', 'laundry'
  ] }
  validates :wattage, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
