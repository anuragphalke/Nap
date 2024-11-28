class UserAppliance < ApplicationRecord
  attr_accessor :brand
  # Associations
  belongs_to :user
  belongs_to :all_appliance
  has_many :routines, dependent: :destroy


end
