class RoutinesController < ApplicationController
  before_action :set_routine, only: %i[show edit update destroy]
  before_action :set_user_appliance, only: [:create]

  def index
    @routines = Routine.joins(:user_appliance).where(user_appliances: { user_id: current_user.id })
  end

  def show
  end

  def new
    @user_appliance = UserAppliance.find(params[:user_appliance_id])
    @routine = Routine.new
    # No need to set @user_appliance here since it's already done in set_user_appliance callback
  end

  def create
    @routine = Routine.new(routine_params)
    @routine.user_appliance = @user_appliance  # Set the user_appliance correctly

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
    routines_with_same_lineage = @routine.user_appliance.routines.where(lineage: @routine.lineage)
    routines_with_same_lineage.destroy_all
    redirect_to user_appliance_path(@routine.user_appliance), status: :see_other, notice: 'Routine deleted'
  end

  private

  def set_user_appliance
    if params[:routine][:request_origin]
    @user_appliance = UserAppliance.find(params[:routine][:user_appliance_id]) # Ensure the user_appliance is correctly set
    else
      @user_appliance = UserAppliance.find(params[:user_appliance_id])
    end
  end

  def set_routine
    @routine = Routine.find(params[:id])
  end

  def routine_params
    params.require(:routine).permit(:name, :starttime, :endtime, :day, :cost, :lineage, :user_appliance_id)
  end
end
