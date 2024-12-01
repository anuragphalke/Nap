# rubocop:disable Layout/LineLength
class Routine < ApplicationRecord
  # Associations
  belongs_to :user_appliance
  has_many :recommendations, dependent: :destroy

  after_save :set_lineage

  # Validations
  # validates :starttime, presence: true, format: { with: /\A([01]?[0-9]|2[0-3]):([0-5][0-9])\z/, message: "must be a valid time in HH:MM format" }
  # validates :endtime, presence: true, format: { with: /\A([01]?[0-9]|2[0-3]):([0-5][0-9])\z/, message: "must be a valid time in HH:MM format" }
  validates :day, presence: true, inclusion: { in: [1, 2, 3, 4, 5, 6, 7], message: "%<value>s is not a valid day" }

  private

  def set_lineage
    return self.update(lineage: self.id) unless self.lineage
  end
end
# rubocop:enable Layout/LineLength
