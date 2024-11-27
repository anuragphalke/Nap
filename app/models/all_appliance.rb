class AllAppliance < ApplicationRecord
  has_many :user_appliances


  # Constants for valid categories and subcategories
  CATEGORIES = {
    "kitchen" => ["Oven", "Dishwasher"],
    "EV charger" => ["EV Charger"],
    "entertainment" => ["TV"],
    "climate control" => ["Air Conditioner", "Heater"],
    "laundry" => ["Washing Machine", "Dryer"]
  }
  # Validations
  validates :model, :brand, presence: true
  # Validation for category and subcategory presence
  validates :category, presence: true
  validates :subcategory, presence: true

   # Validation to check that subcategory belongs to the correct category
   validates :subcategory, inclusion: {
    in: ->(all_appliance) { CATEGORIES[all_appliance.category] || [] },
    message: "must be a valid subcategory for the given category"
  }


  validates :wattage, numericality: { greater_than: 0, only_integer: true }
end
