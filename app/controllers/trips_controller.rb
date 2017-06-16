class TripsController < ApplicationController
  def index
    @trips = Trip.all
  end

  def show
    @trip = Trip.find_by(id: params[:id])
    @user = @trip.user
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
      redirect_to user_path(current_user)
    else
      render :new
    end
  end

  def new
    @trip = Trip.new
  end

  def update
    @trip = Trip.find_by(id: params[:id])
    if @trip.update(trip_params)
      redirect_to trip_path(@trip)
    else
      flash[:error] = "Something went wrong"
      redirect_to trip_path(@trip)
    end
  end



  private
  def trip_params
    params.require(:trip).permit(:trip_name, :photo)
  end
end
