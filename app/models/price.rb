class Price < ApplicationRecord
  # Validations
  validates :date, presence: true, date: { message: "must be a valid date" }
  # validates :hour00, numericality: { allow_nil: true, only_integer: false, message: "must be a valid decimal number" }
  # validates :hour01, numericality: { allow_nil: true, only_integer: false, message: "must be a valid decimal number" }
  # validates :hour02, numericality: { allow_nil: true, only_integer: false, message: "must be a valid decimal number" }
  # validates :hour03, numericality: { allow_nil: true, only_integer: false, message: "must be a valid decimal number" }
  # validates :hour04, numericality: { allow_nil: true, only_integer: false, message: "must be a valid decimal number" }
  # validates :hour05, numericality: { allow_nil: true, only_integer: false, message: "must be a valid decimal number" }
  # validates :hour06, numericality: { allow_nil: true, only_integer: false, message: "must be a valid decimal number" }
  # validates :hour07, numericality: { allow_nil: true, only_integer: false, message: "must be a valid decimal number" }
  # validates :hour08, numericality: { allow_nil: true, only_integer: false, message: "must be a valid decimal number" }
  # validates :hour09, numericality: { allow_nil: true, only_integer: false, message: "must be a valid decimal number" }
  # validates :hour10, numericality: { allow_nil: true, only_integer: false, message: "must be a valid decimal number" }
  # validates :hour11, numericality: { allow_nil: true, only_integer: false, message: "must be a valid decimal number" }
  # validates :hour12, numericality: { allow_nil: true, only_integer: false, message: "must be a valid decimal number" }
  # validates :hour13, numericality: { allow_nil: true, only_integer: false, message: "must be a valid decimal number" }
  # validates :hour14, numericality: { allow_nil: true, only_integer: false, message: "must be a valid decimal number" }
  # validates :hour15, numericality: { allow_nil: true, only_integer: false, message: "must be a valid decimal number" }
  # validates :hour16, numericality: { allow_nil: true, only_integer: false, message: "must be a valid decimal number" }
  # validates :hour17, numericality: { allow_nil: true, only_integer: false, message: "must be a valid decimal number" }
  # validates :hour18, numericality: { allow_nil: true, only_integer: false, message: "must be a valid decimal number" }
  # validates :hour19, numericality: { allow_nil: true, only_integer: false, message: "must be a valid decimal number" }
  # validates :hour20, numericality: { allow_nil: true, only_integer: false, message: "must be a valid decimal number" }
  # validates :hour21, numericality: { allow_nil: true, only_integer: false, message: "must be a valid decimal number" }
  # validates :hour22, numericality: { allow_nil: true, only_integer: false, message: "must be a valid decimal number" }
  # validates :hour23, numericality: { allow_nil: true, only_integer: false, message: "must be a valid decimal number" }

  with_options numericality: { allow_nil: true, only_integer: false, message: "must be a valid decimal number" } do
    validates :hour00, :hour01, :hour02, :hour03, :hour04, :hour05, :hour06,
              :hour07, :hour08, :hour09, :hour10, :hour11, :hour12, :hour13,
              :hour14, :hour15, :hour16, :hour17, :hour18, :hour19, :hour20,
              :hour21, :hour22, :hour23
  end
end
