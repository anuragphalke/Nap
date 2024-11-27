class UserAppliancesController < ApplicationController

  def index
    @prices = Price.all
    @user_appliances = UserAppliance.all

    if params[:category].present?
      @user_appliances = @user_appliances.where(category: params[:category])
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
    @user_appliance = UserAppliance.find(params[:id])
  end

  def new
    @user_appliance = UserAppliance.new
  end

  def create

    @user_appliance = UserAppliance.new(appliance_params)
    @user_appliance.user_id = current_user.id

    if @user_appliance.save
      redirect_to @user_appliance, notice: "appliance was created"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @user_appliance = UserAppliance.find(params[:id])
    @user_appliance.destroy
    redirect_to appliances_path, notice: "appliance deleted"
  end

  private

  def appliance_params
    params.require(:user_appliance).permit(:name, :subcategory)
  end
end
