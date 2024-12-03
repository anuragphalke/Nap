class PagesController < ApplicationController
  require 'date'

  skip_before_action :authenticate_user!, only: [:home]

  def home
    current_time = DateTime.now.beginning_of_hour
    @price_rn = Price.find_by(datetime: current_time)

    today_start = Date.today.beginning_of_day
    today_end = Date.today.end_of_day

    @max_price = Price.where(datetime: today_start..today_end).maximum(:cost)
    @min_price = Price.where(datetime: today_start..today_end).minimum(:cost)

    @price_rn = Price.find_by(datetime: current_time)
    @average_prices = Price # TODO: This needs to change to Average.all
                        .select("EXTRACT(HOUR FROM datetime) AS hour, EXTRACT(DOW FROM datetime) AS day, AVG(cost) AS average_price")
                        .group("EXTRACT(HOUR FROM datetime), EXTRACT(DOW FROM datetime)")
                        .order("day, hour")

    costs = Price.where(datetime: Date.today.all_day)
    # Format the data into the required format: [{ x: hour, y: cost }]
    formatted_data = costs.map do |hour|
      { x: hour.datetime.strftime("%H").to_i, y: hour.cost.round(4) }
    end
    statistics
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
    @total_savings = total_savings
    @savings_this_year = savings_this_year
  end

  private

  def total_savings
    @user_appliances = current_user.user_appliances
    @total_savings = 0.0

    @user_appliances.each do |user_appliance|
      routines = user_appliance.routines.group_by(&:lineage)

      routines.each_value do |lineage_routines|
        first_routine = lineage_routines.min_by(&:id)
        last_routine = lineage_routines.max_by(&:id)

        if first_routine.cost && last_routine.cost
          savings = calculate_savings(first_routine.cost, last_routine.cost)
          @total_savings += savings
        end
      end
    end

    return @total_savings
  end

  def savings_this_year
    today = Date.today
    days_passed = today.yday # Gets the day of the year (1-365 or 1-366 for leap years)
    days_in_year = Date.gregorian_leap?(today.year) ? 366 : 365 # Checks if it's a leap year
    yearly_fraction = days_passed.to_f / days_in_year

    yearly_fraction * @total_savings
  end

  private

  def calculate_savings(original_cost, recommended_cost)
    (original_cost - recommended_cost) * 52
  end
end
