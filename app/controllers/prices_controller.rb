class PricesController < ApplicationController
  skip_before_action :authenticate_user!

  def create
    @price = Price.new(price_params)

    if @price.save
      render json: { message: 'success!' }
    else
      render json: { message: 'failure' }
    end
  end

  private

  def price_params
    params.require(:price).permit(:datetime, :price)
  end
end
