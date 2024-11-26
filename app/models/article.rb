class Article < ApplicationRecord
  # Validations
  validates :title, presence: true
  validates :content, presence: true
  validates :category, presence: true, inclusion: { in: [
    'air conditioner', 'washing machine', 'dishwasher', 'EV Charger', 'boiler/heating', 'TV & Consoles'
  ] }
end
