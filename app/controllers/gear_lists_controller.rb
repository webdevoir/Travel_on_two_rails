class GearListsController < ApplicationController

  before_action :load_trip
  before_filter :require_permission, only: [:create, :update]

  def create
    @gear_list = GearList.new(gear_list_params)
    @gear_list.trip_id = @trip.id
    if @gear_list.save
      redirect_to trip_path(@trip)
    else
      flash[:error] = "Something went wrong"
      redirect_to trip_path(@trip)
    end
  end

  def update
    @gear_list = GearList.find(params[:id])
    @gear_list.trip_id = @trip.id
    if @gear_list.update(gear_list_params)
      redirect_to trip_path(@trip)
    else
      flash[:error] = "Something went wrong"
      redirect_to trip_path(@trip)
    end
  end

  private
  def gear_list_params
    params.require(:gear_list).permit(:bike, :pannier, :tent, :other)
  end

  def load_trip
    @trip = Trip.find(params[:trip_id])
  end

  def require_permission
    if current_user != Trip.find(params[:trip_id]).user
      redirect_to root_path
    end
  end

end
