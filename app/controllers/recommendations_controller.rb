# rubocop:disable Metrics/MethodLength
# rubocop:disable Layout/LineLength
class RecommendationsController < ApplicationController
  def index
    if params[:routine_id].present?
      @routine = Routine.find(params[:routine_id])
      @new_routine = Routine.new

      # Build recommendations and populate instance variables
      build_recommendations(@routine)
    else
      redirect_to all_recommendations_path
    end
  end

  def build_recommendations(routine)
    @duration = ((routine.endtime - routine.starttime) / 3600).round # Converts duration into hours
    @day = routine.day # Converts the routine's day to an integer (1..7)

    averages = fetch_averages_for_day(@day, @duration) # Returns the averages for the present day + extended window (6 hours)
    best_slots = find_best_slots(averages, @duration) # Returns array of 3 cheapest total averages of each 'duration' houred set of options

    original_cost = calculate_routine_cost(routine.starttime, routine.endtime, @duration) # Retrieves cost of the current routine

    @recommendation_response = []
    @savings = []
    @today = []
    @weekdays = %w[Monday Tuesday Wednesday Thursday Friday Saturday Sunday]

    best_slots.reverse.each do |slot|
      recommendation_start_time, recommendation_end_time = calculate_times(averages, slot, @duration) # Calculates start and end time based on index in total averages array
      recommended_cost = slot[:total_cost] # Calculates cost of each recommendation
      @savings << (calculate_savings(original_cost, recommended_cost) * -1) # Calculates annual savings based on a 52-week year

      @recommendation_response << Recommendation.create(
        cost: slot[:total_cost],
        routine_id: routine.id,
        starttime: recommendation_start_time,
        endtime: recommendation_end_time
      )

      @slot = slot[:day]
      @today << (@slot == @day ? @weekdays[@day - 1] : @weekdays[@slot - 1])
    end
  end

  def all
    user_appliances = UserAppliance.where(user_id: current_user.id)
    @latest_routines = Routine
                        .select("DISTINCT ON (lineage) *")
                        .where(user_appliance_id: user_appliances.pluck(:id))
                        .order(:lineage, id: :desc)
    @recommendations_grouped = @latest_routines.includes(:recommendations).map do |routine|
      appliance = UserAppliance.find(routine.user_appliance_id)
      recommendations = routine.recommendations.first(3)
      { appliance: appliance, routine: routine, recommendations: recommendations }
    end
  end

  private

  def fetch_averages_for_day(day, duration)
    day_1_averages = Average.where(day: day).order(:time)
    day_2_averages = Average.where(day: day + 1).where("EXTRACT(HOUR FROM time) < ?", 7).order(:time)

    combined_averages = day_1_averages + day_2_averages
    raise "Not enough data for the requested duration" if combined_averages.size < duration

    combined_averages
  end

  def find_best_slots(averages, duration)
    total_averages = []

    (0..(averages.size - duration)).each do |start_index|
      adjusted_duration = duration
      adjusted_duration = 24 + duration if duration.negative?

      if start_index + adjusted_duration <= averages.size
        total_cost = averages[start_index, adjusted_duration].sum(&:average)

        if start_index + adjusted_duration > 23
          remaining_duration = adjusted_duration - (24 - start_index)
          next_day_slot = averages[0, [remaining_duration, 7].min]
          total_cost += next_day_slot.sum(&:average)
        end

        day = start_index < 23 ? @day : @day + 1

        total_averages << { total_cost: total_cost, start_index: start_index, day: day }
      end
    end

    total_averages.sort_by { |slot| slot[:total_cost] }.first(3)
  end

  def calculate_times(averages, slot, duration)
    start_index = slot[:start_index]
    start_time = averages[start_index].time
    end_time = start_time + (duration * 3600)
    [start_time, end_time]
  end

  def calculate_routine_cost(starttime, endtime, duration)
    averages = Average.where("time >= ? AND time <= ?", starttime, endtime).order(:time)
    averages.first(duration).sum(&:average)
  end

  def calculate_savings(original_cost, recommended_cost)
    (original_cost - recommended_cost) * 52
  end
end
# rubocop:enable Metrics/MethodLength
# rubocop:enable Layout/LineLength
