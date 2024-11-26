class PricesController < ApplicationController
  def create
    @price = Price.new(price_params)

    if @price.save
      redirect_to @price
    else
      render :new
    end
  end

  private

  def price_params
    params.require(:price).permit(:datetime, :price)
  end
end
