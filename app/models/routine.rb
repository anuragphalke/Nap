# rubocop:disable Layout/LineLength
# rubocop:disable Metrics/MethodLength
# rubocop:disable Style/Next
class Routine < ApplicationRecord
  # Associations
  belongs_to :user_appliance
  has_many :recommendations, dependent: :destroy

  # before_save :calculate_cost
  after_save :set_lineage, :generate_recommendations
  after_commit :calculate_cost

  # Validations
  # validates :starttime, presence: true, format: { with: /\A([01]?[0-9]|2[0-3]):([0-5][0-9])\z/, message: "must be a valid time in HH:MM format" }
  # validates :endtime, presence: true, format: { with: /\A([01]?[0-9]|2[0-3]):([0-5][0-9])\z/, message: "must be a valid time in HH:MM format" }
  validates :day, presence: true, inclusion: { in: [1, 2, 3, 4, 5, 6, 7], message: "%<value>s is not a valid day" }

  def calculate_cost
    duration = ((self.endtime - self.starttime) / 1.hour).to_i
    averages = fetch_averages_for_day(self.day, duration)

    if self.cost.nil?
    # Calculate total cost based on the averages and duration
      self.cost = calculate_routine_cost(self.starttime, self.endtime, duration, averages)
      self.save
    end
  end

  def generate_recommendations
    RecommendationsController.new.send(:build_recommendations, self)
  end

  private

  def fetch_averages_for_day(day, duration)
    day_1_averages = Average.where(day: day).order(:time)
    day_2_averages = Average.where(day: day + 1).where("EXTRACT(HOUR FROM time) < ?", 7).order(:time)

    combined_averages = day_1_averages + day_2_averages

    if combined_averages.size < duration
      raise "Not enough data for the requested duration. Only #{combined_averages.size} averages available, but #{duration} required."
    end

    combined_averages
  end

  def calculate_routine_cost(starttime, endtime, duration, averages)
    total_cost = 0

    # Adjust duration if negative
    adjusted_duration = duration < 0 ? 24 + duration : duration

    # Check if we have enough data in averages to calculate the total cost
    if averages.size < adjusted_duration
      raise "Insufficient averages data for the requested duration"
    end

    # Iterate through all possible start indices
    (0..(averages.size - adjusted_duration)).each do |start_index|
      # Calculate cost for the given duration
      total_cost = averages[start_index, adjusted_duration].sum(&:average)

      # Skip iteration if the adjusted duration exceeds the available hours in a single day
      if start_index + adjusted_duration > 23
        remaining_duration = adjusted_duration - (24 - start_index)
        next_day_slot = averages[0, [remaining_duration, 7].min]
        total_cost += next_day_slot.sum(&:average)
        next  # Skip the iteration for the current loop
      end
    end

    total_cost
  end

  def set_lineage
    return self.update(lineage: self.id) unless self.lineage
  end
end
# rubocop:enable Layout/LineLength
# rubocop:enable Style/Next
# # rubocop:enable Metrics/MethodLength
