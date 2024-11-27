class PricesController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    @prices = Price.all
  end

  def create
    @price = Price.new(price_params)

    if @price.save
      render json: { message: 'success!' }
    else
      render json: { message: 'failure' }
    end
  end


  def average_prices
    # Execute the query to get the average price by day and hour
    @average_prices = Price
      .select("EXTRACT(HOUR FROM datetime) AS hour, EXTRACT(DOW FROM datetime) AS day, AVG(cost) AS average_price")
      .group("EXTRACT(HOUR FROM datetime), EXTRACT(DOW FROM datetime)")
      .order("day, hour")

      
  end

  private

  def price_params
    params.require(:price).permit(:datetime, :cost)
  end
end
