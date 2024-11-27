class RoutinesController < ApplicationController
  before_action :set_routine, only: [:show, :edit, :update, :destroy]
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
    if @routine.save
      redirect_to routine_path(@routine), notice: 'Routine was successfully created.'
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
    params.require(:routine).permit(:user_appliance_id, :cost, :starttime, :endtime, :day)
  end

end
