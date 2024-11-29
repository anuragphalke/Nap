class RoutinesController < ApplicationController
  before_action :set_routine, only: %i[show edit update destroy]

  def index
    @routines = Routine.joins(:user_appliance).where(user_appliances: { user_id: current_user.id })
  end

  def show
  end

  def new
    @routine = Routine.new
    @user_appliance = UserAppliance.find(params[:user_appliance_id])
  end

  def create
    @routine = Routine.new(routine_params)

    unless params[:routine][:request_origin]
      @user_appliance = UserAppliance.find(params[:user_appliance_id])
      @routine.user_appliance_id = params[:user_appliance_id] # Link to the user_appliance
    end

    if @routine.save

      redirect_to user_appliance_path(@routine.user_appliance), notice: 'Routine created'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @routine.update(routine_params)
      redirect_to user_appliance_path(@routine.user_appliance), notice: 'Routine updated'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @routine.destroy

    redirect_to user_appliance_path(@routine.user_appliance), status: :see_other, notice: 'Routine was successfully deleted.'
  end

  private

  def set_lineage

  end

  def set_routine
    @routine = Routine.find(params[:id])
  end

  def user_applaince

  end

  def routine_params
    params.require(:routine).permit(:name, :starttime, :endtime, :day, :cost, :lineage, :user_appliance_id)
  end
end
