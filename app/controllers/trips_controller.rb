class TripsController < ApplicationController
  def index
    @trips = Trip.all
  end

  def show
    @trip = Trip.find_by(id: params[:id])
    @posts = @trip.posts
    if @trip.blank?
      redirect_to new_trip_url
    end
  end

  def create
    @trip = Trip.new(trip_params)

    if current_user
      @trip.user_id = current_user.id
    end

    if @trip.save
      redirect_to trips_url
    else
      render :new
    end
  end

  def new
    @btrip = Trip.new
  end



  private
  def trip_params
    params.require(:trip).permit(:trip_name)
  end
end
