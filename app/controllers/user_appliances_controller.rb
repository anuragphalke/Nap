class UserAppliancesController < ApplicationController
  before_action :set_user_appliance, only: [:show, :edit, :update, :destroy]

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
    @average_prices = Price
      .select("EXTRACT(HOUR FROM datetime) AS hour, EXTRACT(DOW FROM datetime) AS day, AVG(cost) AS average_price")
      .group("EXTRACT(HOUR FROM datetime), EXTRACT(DOW FROM datetime)")
      .order("day, hour")
  end

  def show
  end

  def new
    @user_appliance = UserAppliance.new
  end

  def create
    @user_appliance = UserAppliance.new(appliance_params)
    @user_appliance.user_id = current_user.id

    if @user_appliance.save
      redirect_to @user_appliance, notice: "Appliance was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    @user_appliance = UserAppliance.find(params[:id])

    if @user_appliance.user_id == current_user.id
      if @user_appliance.update(appliance_params)
        redirect_to @user_appliance, notice: "Appliance was successfully updated."
      else
        render :edit, status: :unprocessable_entity
      end
    else
      redirect_to user_appliances_path, alert: "You are not authorized to edit this appliance."
    end
  end


  def destroy
    @user_appliance.destroy
    redirect_to user_appliances_path, notice: "Appliance was successfully deleted."
  end

  private

  def set_user_appliance
    @user_appliance = UserAppliance.find(params[:id])
  end

  def appliance_params
    params.require(:user_appliance).permit(:category, :subcategory, :brand, :all_appliance_id)
  end
end
