# rubocop:disable Metrics/MethodLength
# rubocop:disable Layout/LineLength
# rubocop:disable Metrics/ClassLength
# rubocop:disable Style/RedundantAssignment
# rubocop:disable Style/HashSyntax
class PagesController < ApplicationController
  require 'date'

  skip_before_action :authenticate_user!, only: [:landing]

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
    @statistics = statistics

    @comparator_data = statistics
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
    if current_user&.user_appliances&.exists?
      applied_savings = calculate_applied_savings
      potential_savings = calculate_potential_savings
      consumption = calculate_current_consumption
      applied_savings_this_year = prorate_savings(applied_savings)
      rating = calculate_rating(applied_savings, potential_savings)

      initial_rate = (calculate_initial_cost / calculate_total_duration)
      current_rate = (calculate_current_cost / calculate_total_duration)

      improvement = ((current_rate - initial_rate) / initial_rate) * 100

      @statistics = {
        rating: rating,
        applied_savings: applied_savings_this_year,
        total_savings: applied_savings,
        consumption: consumption,
        improvement: improvement,
        initial_rate: initial_rate,
        current_rate: current_rate
      }
    else
      @statistics = {
        rating: "N/A",
        applied_savings: 0.0,
        total_savings: 0.0,
        consumption: 0.0,
        improvement: 0.0,
        initial_rate: 0.0,
        current_rate: 0.0
      }
    end
    @comparator_data = [ { x: "Initial", y: @statistics[:initial_rate] }, { x: "Current", y: @statistics[:current_rate] } ].to_json


  end

  private

  def calculate_applied_savings
    calculate_savings do |lineage|
      (lineage.first.cost - lineage.last.cost) * 52
    end
  end

  def calculate_potential_savings
    calculate_savings do |lineage|
      (lineage.first.cost - lineage.last.recommendations.first.cost) * 52
    end
  end

  def calculate_current_consumption
    calculate_routine_attribute(:desc) do |routine|
      duration = routine_duration(routine)
      duration * (routine.user_appliance.all_appliance.wattage / 1000) * 52
    end
  end

  def calculate_total_duration
    calculate_routine_attribute(:desc) do |routine|
      routine_duration(routine) * 52
    end
  end

  def calculate_initial_cost
    calculate_routine_attribute(:asc) { |routine| routine.cost * 52 }
  end

  def calculate_current_cost
    calculate_routine_attribute(:desc) { |routine| routine.cost * 52 }
  end

  def prorate_savings(applied_savings)
    today = Date.today
    days_passed = today.yday
    days_in_year = Date.gregorian_leap?(today.year) ? 366 : 365
    yearly_fraction = days_passed.to_f / days_in_year

    yearly_fraction * applied_savings
  end

  def calculate_rating(applied_savings, potential_savings)
    return 'N/A' if potential_savings.zero?

    score = (applied_savings / potential_savings) * 100
    case score
    when 80..100 then 'A+'
    when 60..79 then 'A'
    when 40..59 then 'B+'
    when 20..39 then 'B-'
    else 'C'
    end
  end

  # Shared query logic for routines grouped by lineage
  def fetch_routines(order_by)
    Routine.joins(user_appliance: :user)
           .where(user_appliances: { user_id: current_user.id })
           .order(:lineage, id: order_by)
           .group_by(&:lineage)
           .map { |_, routines| routines.first }
  end

  # Calculate savings by applying a block to each lineage
  def calculate_savings
    applied_savings = 0
    lineages = Routine.joins(user_appliance: :user)
                      .where(user_appliances: { user_id: current_user.id })
                      .order(:lineage, "id ASC", :starttime)
                      .group_by(&:lineage)
                      .values
    lineages.each { |lineage| applied_savings += yield(lineage) }
    applied_savings
  end

  # Calculate an attribute for routines based on order and block logic
  def calculate_routine_attribute(order_by)
    total = 0
    routines = fetch_routines(order_by)
    routines.each { |routine| total += yield(routine) }
    total
  end

  # Helper to calculate routine duration in hours
  def routine_duration(routine)
    (routine.endtime - routine.starttime) / 1.hour
  end
end
# rubocop:enable Metrics/MethodLength
# rubocop:enable Layout/LineLength
# rubocop:enable Metrics/ClassLength
# rubocop:enable Style/RedundantAssignment
# rubocop:enable Style/HashSyntax
