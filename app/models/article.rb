class Article < ApplicationRecord
  # Validations
  validates :title, presence: true
  validates :content, presence: true
  validates :category, presence: true, inclusion: { in: [
    'air conditioning', 'washing machine', 'dishwasher', 'EV Charger', 'heating', 'TV & Consoles'
  ] }
end
