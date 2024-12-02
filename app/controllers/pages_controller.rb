class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]

  def home
    current_time = DateTime.now.beginning_of_hour
    @price_rn = Price.find_by(datetime: current_time)

    today_start = Date.today.beginning_of_day
    today_end = Date.today.end_of_day

    @max_price = Price.where(datetime: today_start..today_end).maximum(:cost)
    @min_price = Price.where(datetime: today_start..today_end).minimum(:cost)

    @price_rn = Price.find_by(datetime: current_time)
    @average_prices = Price
                        .select("EXTRACT(HOUR FROM datetime) AS hour, EXTRACT(DOW FROM datetime) AS day, AVG(cost) AS average_price")
                        .group("EXTRACT(HOUR FROM datetime), EXTRACT(DOW FROM datetime)")
                        .order("day, hour")

    costs = Price.where(datetime: Date.today.all_day)
    # Format the data into the required format: [{ x: hour, y: cost }]
    formatted_data = costs.map do |hour|
      { x: hour.datetime.strftime("%H").to_i, y: hour.cost.round(4) }
    end
    @formatted_data = formatted_data.to_json
  end

  def price_today
    costs = Price.where(datetime: Date.today.all_day)

    # Format the data into the required format: [{ x: hour, y: cost }]
    formatted_data = costs.map do |hour|
      { x: hour.datetime.strftime("%H").to_i, y: hour.cost.round(4) }
    end

    formatted_data
  end

  def statistics
    @user = current_user # Assuming you're working with the current logged-in user
    @total_savings = 0.0

    @user.user_appliances.each do |user_appliance|
      # For each user appliance, calculate savings for all lineages
      lineages = user_appliance.routines.group_by(&:lineage)

      lineages.each_value do |routines|
        # Find the routine with the lowest id (earliest) and the highest id (latest)
        first_routine = routines.min_by(&:id)
        last_routine = routines.max_by(&:id)

        # Skip iteration if either min_routine or max_routine is nil
        next unless first_routine && last_routine

        if first_routine.cost.nil? || last_routine.cost.nil?
          next
        end

        # Calculate the savings based on the difference in cost
        savings = (first_routine.cost - last_routine.cost) * 52
        @total_savings += savings
      end
    end
  end
end
