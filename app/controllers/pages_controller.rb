class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home ]

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
end
