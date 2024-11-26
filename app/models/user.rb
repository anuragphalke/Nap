# rubocop:disable Layout/LineLength
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Associations
  has_many :appliances, dependent: :destroy

  # Validations
  validates :username, presence: true, uniqueness: true, format: { with: /\A\w+\z/, message: "must contain only letters, numbers, and underscores without spaces" }
  validates :email, format: { with: /\A\S+@\S+\.\S+\z/, message: "must type a valid email format." }
  validates :password, presence: true, length: { minimum: 8 }, format: {
    with: /\A(?=.*[A-Z])(?=.*[a-z])(?=.*\d).+\z/,
    message: "must include at least one uppercase letter, one lowercase letter, and one number"
  }, if: -> { new_record? || !password.nil? }
end
# rubocop:enable Layout/LineLength
