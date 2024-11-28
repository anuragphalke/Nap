class RecommendationsController < ApplicationController
  def index
    @recommendations = Recommendation.all
  end

  def recommend
    @routine = Routine.find(params[:id])
    @duration = ((@routine.endtime - @routine.starttime) / 3600).round # Converts duration into duration in hours
    @day = @routine.day.to_i # Converts the routine's day to an integer (1..7)

    averages = fetch_averages_for_day(@day, @duration) # returns the averages for present day + extended window (6 hours)
    best_slots = find_best_slots(averages, @duration) # returns array of 3 cheapest total averages of each 'duration' houred set of options

    original_cost = calculate_routine_cost(@routine.starttime, @routine.endtime, @duration) # retrieves cost of current routine

    recommendations = best_slots.reverse.each_with_index.map do |slot, index| # builds an array of best 3 recommendations
      recommendation_start_time, recommendation_end_time = calculate_times(averages, slot, @duration) # Calculates start and end time based on index in total averages array
      recommended_cost = slot[:total_cost] # Calcuates cost of each recommendation
      savings = calculate_savings(original_cost, recommended_cost) * -1 # Calculates annual savings based on a 52 week year

      Recommendation.create(
        cost: slot[:total_cost],
        routine_id: @routine.id,
        starttime: recommendation_start_time,
        endtime: recommendation_end_time
      )

      # This needs to be in the View
      if recommendation_end_time.hour < recommendation_start_time.hour # Checks if the recommendation crosses into the next day MAJOR FLAW HERE < how does it know if 00:00 - 02:00 is today or tomorrow?
        "If you set your routine to begin at #{recommendation_start_time.strftime('%H:%M')} today and end at #{recommendation_end_time.strftime("%H:%M")} tomorrow, a #{@duration} hour routine will save you €#{savings} per year"
      else
        "If you set your routine to begin at #{recommendation_start_time.strftime('%H:%M')} #{slot[:day]} and end at #{recommendation_end_time.strftime("%H:%M")}, a #{@duration} hour routine will save you €#{savings} per year"
      end
    end

    #  render json: recommendations
    # rescue StandardError => e
    # render json: { error: e.message }, status: :unprocessable_entity
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
      total_cost = averages[start_index, duration].sum(&:average)
      day = start_index < 23 ? "today" : "tomorrow"
      total_averages << { total_cost: total_cost, start_index: start_index, day: day }
    end

    # Sort by total cost and return the top 3 cheapest slots
    total_averages.sort_by { |slot| slot[:total_cost] }.first(3)
  end

  def calculate_times(averages, slot, duration)
    start_index = slot[:start_index]
    start_time = averages[start_index].time

    # Calculate end time based on the duration
    end_time = start_time + (duration * 3600)

    [start_time, end_time]
  end

  def calculate_routine_cost(starttime, endtime, duration)
    # Calculate the cost of the routine with the given start and end times
    averages = Average.where("time >= ? AND time <= ?", starttime, endtime).order(:time)
    averages.first(duration).sum(&:average)
  end

  def calculate_savings(original_cost, recommended_cost)
    # Calculate the savings per year
    (original_cost - recommended_cost) * 52
  end
end
