class UserAppliance < ApplicationRecord
  # Associations
  belongs_to :user
  belongs_to :all_appliance
  has_many :routines, dependent: :destroy

  
end
