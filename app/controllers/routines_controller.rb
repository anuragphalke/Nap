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
    @routine.user_appliance_id = params[:user_appliance_id] # Link to the user_appliance

    if @routine.save
      redirect_to user_appliance_path(@user_appliance), notice: 'Routine was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @routine.update(routine_params)
      redirect_to routine_path(@routine), notice: 'Routine was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @routine.destroy

    redirect_to routines_path, status: :see_other, notice: 'Routine was successfully deleted.'
  end

  private

  def set_routine
    @routine = Routine.find(params[:id])
  end

  def routine_params
    params.require(:routine).permit(:name, :starttime, :endtime, :day, :cost)
  end
end
