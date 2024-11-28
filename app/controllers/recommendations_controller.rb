class RecommendationsController < ApplicationController

  def index
    @recommendations = Recommendation.all
  end
  def recommend
    @routine = Routine.last # Replace with params[:id] or relevant fetching logic
    @duration = ((@routine.endtime - @routine.starttime) / 3600).round
    @day = @routine.day.to_i

    # Fetch relevant averages for the given day and the extended window (same day + 7 hours of next day)
    averages = fetch_averages_for_day(@day, @duration)

    # Compute the optimal slot
    cheapest_slot = find_cheapest_slot(averages, @duration)

    # Extract start and end times from the result
    recommendation_start_time, recommendation_end_time = calculate_times(averages, cheapest_slot, @duration)

    # Save or return the recommendation
    Recommendation.create!(
      routine: @routine,
      cost: cheapest_slot[:total_cost],
      starttime: recommendation_start_time,
      endtime: recommendation_end_time
    )

    render json: { start_time: recommendation_start_time.strftime("%H:%M"), end_time: recommendation_end_time.strftime("%H:%M") }
  rescue StandardError => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  private

  def fetch_averages_for_day(day, duration)
    day_1_averages = Average.where(day: day).order(:time)
    day_2_averages = Average.where(day: day + 1).where("EXTRACT(HOUR FROM time) < ?", 7).order(:time)

    combined_averages = day_1_averages + day_2_averages
    p day_1_averages
    p day_2_averages
    p combined_averages
    raise "Not enough data for the requested duration" if combined_averages.size < duration

    combined_averages
  end

  def find_cheapest_slot(averages, duration)
    total_averages = []

    # Sliding window sum to calculate costs for consecutive slots
    (0..(averages.size - duration)).each do |start_index|
      total_cost = averages[start_index, duration].sum(&:average)
      total_averages << { total_cost: total_cost, start_index: start_index }
    end

    # Return the slot with the minimum total cost
    total_averages.min_by { |slot| slot[:total_cost] }
  end

  def calculate_times(averages, slot, duration)
    start_index = slot[:start_index]
    start_time = averages[start_index].time

    # Calculate end time based on the duration
    end_time = start_time + (duration * 3600)

    [start_time, end_time]
  end
end
