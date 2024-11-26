class Price < ApplicationRecord
  validates :price, presence: true
  validates :datetime, presence: true
end
