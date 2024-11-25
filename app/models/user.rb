# rubocop:disable Layout/LineLength
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Associations
  has_many :devices, dependent: :destroy

  # Validations
  validates :username, presence: true, uniqueness: true, format: { with: /\A\w+\z/, message: "must contain only letters, numbers, and underscores without spaces" }
end
# rubocop:enable Layout/LineLength
