class PricesController < ApplicationController
  # Display the form for creating a new price
  def new
    @price = Price.new
  end

  # Handle the form submission for creating a new price
  def create
    @price = Price.new(price_params)

    if @price.save
      redirect_to @price, notice: 'Price was successfully created.'
    else
      render :new
    end
  end

  private

  # Strong parameters for price
  def price_params
    params.require(:price).permit(:datetime, :price)
  end
end
