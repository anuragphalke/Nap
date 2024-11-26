class RoutinesController < ApplicationController
  before_action :set_restaurant, only: [:show, :edit, :update, :destroy]
  def index
    @routines = Routine.all
  end

  def show
  end

  def new
    @routine = Routine.new
  end

  def create
    @routine = Routine.new(routine_params)
    @routine.save

    redirect_to routine_path(@routine)
  end

  def edit
  end

  def update
    @routine.update(routine_params)

    redirect_to routine_path(@routine)
  end

  def destroy
    @routine.destroy

    redirect_to routines_path, status: :see_other
  end

  private

  def set_routine
    @routine = Routine.find(params[:id])
  end

  def routine_params
    params.require(:routines).permit(:appliance_id, :cost, :starttime, :endtime, :day)
  end

end
