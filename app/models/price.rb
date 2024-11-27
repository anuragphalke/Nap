class Price < ApplicationRecord
  validates :cost, presence: true
  validates :datetime, presence: true
end
