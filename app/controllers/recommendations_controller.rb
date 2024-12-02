class RecommendationsController < ApplicationController
  def index
    @routine = Routine.find(params[:routine_id])
    @new_routine = Routine.new
    @duration = ((@routine.endtime - @routine.starttime) / 3600).round # Converts duration into duration in hours
    @day = @routine.day # Converts the routine's day to an integer (1..7)

    averages = fetch_averages_for_day(@day, @duration) # returns the averages for present day + extended window (6 hours)
    best_slots = find_best_slots(averages, @duration) # returns array of 3 cheapest total averages of each 'duration' houred set of options

    original_cost = calculate_routine_cost(@routine.starttime, @routine.endtime, @duration) # retrieves cost of current routine

    @recommendation_response = []
    @savings = []
    @today = []
    @weekdays = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]

    best_slots.reverse.each.map do |slot, index| # builds an array of best 3 recommendations
      recommendation_start_time, recommendation_end_time = calculate_times(averages, slot, @duration) # Calculates start and end time based on index in total averages array
      recommended_cost = slot[:total_cost] # Calcuates cost of each recommendation
      @savings << (calculate_savings(original_cost, recommended_cost) * -1) # Calculates annual savings based on a 52 week year

      @recommendation_response << Recommendation.create(
        cost: slot[:total_cost],
        routine_id: @routine.id,
        starttime: recommendation_start_time,
        endtime: recommendation_end_time
      )

      @slot = slot[:day]
      if slot[:day] == @day
        @today << @weekdays[@day - 1]
      else
        @today << @weekdays[slot[:day]]
      end
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

    # Iterate through all possible starting points
    (0..(averages.size - duration)).each do |start_index|
      adjusted_duration = duration

      # If duration is negative (indicating it spans over midnight), adjust it
      if duration < 0
        adjusted_duration = 24 + duration # Convert negative duration to a positive value
      end

      # Check if the start_index leads into the next day
      if start_index + adjusted_duration <= averages.size
        total_cost = averages[start_index, adjusted_duration].sum(&:average)

        # If the routine crosses over midnight, we need to add the first 7 hours of the next day
        if start_index + adjusted_duration > 23
          # Calculate the remaining duration after the first day ends (24th hour)
          remaining_duration = adjusted_duration - (24 - start_index)

          # Account for the first 7 hours of the next day
          next_day_slot = averages[0, [remaining_duration, 7].min] # Limit to first 7 hours of next day
          total_cost += next_day_slot.sum(&:average)
        end

        # Assign the day the routine starts (today or next day)
        day = start_index < 23 ? @day : @day + 1

        total_averages << { total_cost: total_cost, start_index: start_index, day: day }
      end
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
