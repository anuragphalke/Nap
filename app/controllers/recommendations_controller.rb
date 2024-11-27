class RecommendationsController < ApplicationController
  def recommend
    @routine = Routine.last
    @duration = ((@routine.endtime - @routine.starttime) / 3600).round
    @day = @routine.day

    # Filter averages for the first day (00:00 to 23:59)
    @day_1_averages = Average.where(day: @day)
                             .where('EXTRACT(HOUR FROM time) >= ?', 0) # Start from 00:00

    # Filter averages for the second day (00:00 to 07:00)
    @day_2_averages = Average.where(day: @day.to_i + 1)
                             .where('EXTRACT(HOUR FROM time) < ?', 7) # Up to 07:00

    # Combine the two sets of averages
    @all_averages = @day_1_averages + @day_2_averages

    # Check if we have enough averages for the entire duration
    total_hours_available = @all_averages.length
    if total_hours_available < @duration
      raise "Not enough averages available for the given duration. Available: #{total_hours_available}, Required: #{@duration}"
    end

    @total_averages = []

    # Loop through @all_averages and calculate total cost for each valid window
    max_index = total_hours_available - @duration  # Ensure we don't exceed the bounds
    (0..max_index).each do |start_index|
      total_cost = 0
      position = start_index
      @duration.times do
        # Ensure position is within bounds before accessing the array
        total_cost += @all_averages[position].average
        position += 1
      end
      @total_averages << { total_cost: total_cost, start_index: start_index }
    end

    # Find the cheapest slot
    @cheapest_slot = @total_averages.min_by { |slot| slot[:total_cost] }

    # For verification: Log all total costs and the selected cheapest slot
    Rails.logger.info "All slot costs: #{@total_averages}"
    Rails.logger.info "Cheapest slot: #{@cheapest_slot}"

    # Validate programmatically
    min_cost = @total_averages.map { |slot| slot[:total_cost] }.min
    if @cheapest_slot[:total_cost] != min_cost
      raise "Cheapest slot validation failed: Expected #{min_cost}, got #{@cheapest_slot[:total_cost]}"
    end

    # Calculate the start and end time of the cheapest slot
    start_index = @cheapest_slot[:start_index]
    start_hour = @all_averages[start_index].time.hour
    start_minute = @all_averages[start_index].time.min

    # Calculate the end time based on the duration
    end_index = start_index + @duration - 1
    end_hour = @all_averages[end_index].time.hour
    end_minute = @all_averages[end_index].time.min

    # Handle crossing into the next day
    if end_hour < start_hour
      # If end time is less than start time, the routine crosses into the next day
      end_hour += 24
    end

    # Extract the date components from the routine's start time
    start_time = @routine.starttime # Assuming it's a DateTime or Time object
    year = start_time.year
    month = start_time.month
    day = start_time.day

    # Calculate start and end time with correct day handling
    start_time = Time.new(year, month, day, start_hour, start_minute)
    end_time = Time.new(year, month, day, end_hour, end_minute)

    # If the end time is past midnight, adjust the end time to the next day
    if end_hour >= 24
      end_time += 1.day
    end

    # Format start and end times as HH:MM
    formatted_start_time = start_time.strftime("%H:%M")
    formatted_end_time = end_time.strftime("%H:%M")

    # Log the result for further debugging if needed
    raise "Cheapest routine start time: #{formatted_start_time}, end time: #{formatted_end_time}"
  end
end
