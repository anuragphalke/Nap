class AppliancesController < ApplicationController

  def index
    @prices = Price.all
    @appliances = Appliance.all

    if params[:category].present?
      @appliances = @appliances.where(category: params[:category])
    end

    @average_prices = Price
    .select("EXTRACT(HOUR FROM datetime) AS hour, EXTRACT(DOW FROM datetime) AS day, AVG(cost) AS average_price")
    .group("EXTRACT(HOUR FROM datetime), EXTRACT(DOW FROM datetime)")
    .order("day, hour")

  end


  def average_prices
    # Execute the query to get the average price by day and hour
    @average_prices = Price
      .select("EXTRACT(HOUR FROM datetime) AS hour, EXTRACT(DOW FROM datetime) AS day, AVG(cost) AS average_price")
      .group("EXTRACT(HOUR FROM datetime), EXTRACT(DOW FROM datetime)")
      .order("day, hour")


  end


  def show
    @appliance = Appliance.find(params[:id])
  end

  def new
    @appliance = Appliance.new
  end

  def create

    @appliance = Appliance.new(appliance_params)
    @appliance.user_id = current_user.id

    if @appliance.save
      redirect_to @appliance, notice: "appliance was created"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @appliance = Appliance.find(params[:id])
    @appliance.destroy
    redirect_to appliances_path, notice: "appliance deleted"
  end

  private

  def appliance_params
    params.require(:appliance).permit(:name, :category, :wattage)
  end
end
