class AllAppliance < ApplicationRecord
  has_many :user_appliances


  # Constants for valid categories and subcategories
  CATEGORIES = {
    "Kitchen" => ["Oven", "Dishwasher"],
    "EV Charger" => ["EV Charger"],
    "Entertainment" => ["TV"],
    "Climate Control" => ["Air Conditioner", "Heater"],
    "Laundry" => ["Washing Machine", "Dryer"]
  }


  SUBCATEGORY_ICONS = {
    "Oven" => "oven.svg",
    "Dishwasher" => "dishwasher.svg",
    "EV Charger" => "ev-charger.svg",
    "TV" => "tv.svg",
    "Air Conditioner" => "ac.svg",
    "Heater" => "heater.svg",
    "Washing Machine" => "washing-machine.svg",
    "Dryer" => "dryer.svg"
  }
  # Validations
  # validates :model, :brand, presence: true
  # Validation for category and subcategory presence
  # validates :category, presence: true
  # validates :subcategory, presence: true

  # Validation to check that subcategory belongs to the correct category
  #   validates :subcategory, inclusion: {
  #   in: ->(all_appliance) { CATEGORIES[all_appliance.category] || [] },
  #   message: "must be a valid subcategory for the given category"
  # }


  validates :wattage, numericality: { greater_than: 0 }

  def icon_for_subcategory
    SUBCATEGORY_ICONS[self.subcategory]
  end
end
