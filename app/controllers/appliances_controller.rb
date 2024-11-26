class AppliancesController < ApplicationController

  def index

    @appliances = Appliance.all

    if params[:category].present?
      @appliances = @appliances.where(category: params[:category])
    end

  end

  def show
    @appliacne = Appliacne.find(params[:id])
  end

  def new
    @appliance = Appliacne.new
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
