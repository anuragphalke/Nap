# rubocop:disable Metrics/MethodLength
# rubocop:disable Layout/LineLength
class UserAppliancesController < ApplicationController
  before_action :set_user_appliance, only: %i[show edit update destroy]

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

  def show
    @routines = @user_appliance.routines
  end

  def new
    @user_appliance = UserAppliance.new
    @user_appliance.brand = params[:user_appliance][:brand] if params[:user_appliance]&.[](:brand).present?

    @brands = AllAppliance.distinct.pluck(:brand)

    if @user_appliance.brand.present?
      @models = AllAppliance.where(brand: @user_appliance.brand).pluck(:model, :id)
    else
      @models = []
    end

    return render :new if params[:user_appliance]&.[](:brand).present?
  end

  def create
    @user_appliance = UserAppliance.new(appliance_params)
    @user_appliance.user_id = current_user.id

    if params[:user_appliance][:all_appliance_id].blank?
      @brands = AllAppliance.distinct.pluck(:brand)
      @models = AllAppliance.where(brand: @user_appliance.brand).pluck(:model, :id)
      render :new
      return
    end

    if @user_appliance.save
      
      redirect_to @user_appliance, notice: "Appliance was successfully created."
    else
      @brands = AllAppliance.distinct.pluck(:brand)
      @models = AllAppliance.where(brand: @user_appliance.brand).pluck(:model, :id)
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
    params.require(:user_appliance).permit(:all_appliance_id, :brand)
  end
end
# rubocop:enable Metrics/MethodLength
# rubocop:enable Layout/LineLength
