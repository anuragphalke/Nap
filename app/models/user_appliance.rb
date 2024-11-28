class UserAppliance < ApplicationRecord
  attr_accessor :brand
  # Associations
  belongs_to :user
  belongs_to :all_appliance
  has_many :routines, dependent: :destroy

  # Validations
  # validates :nickname, uniqueness: { scope: :user_id, message: "should be unique for your devices" },
  #           format: { with: /\A[a-zA-Z0-9]+\z/, message: "can only contain letters and numbers" },
  #           length: { maximum: 20 }
end
