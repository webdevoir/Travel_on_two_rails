class Api::V1::TripsController < Api::V1::BaseController

  api :get, "trips/:id"
  def show
    trip = Trip.find(params[:id])
    result = TripSerializer.new(trip)

    render(json: result.to_json)
  end

  api :post, "trips"
  param :trip, Hash, :desc => "Params for details of a listing" do
    param :trip_name, String, :desc => "Name of trip"
    param :photo, String, :desc => "Image file of photo"
    param :description, String, :desc => "Description of trip"
    param :start, String, :desc => "start point of the trip (should be google address)"
    param :end, String, :desc => "end point of trip (should be google address)"
  end
  def create
    current_user = User.find(1)
    @user = current_user
    @trip = Trip.new(trip_params)
    @trip.user_id = @user.id
    if @trip.save
      render(json: {:success => "success"}.to_json)
    else
      render(json: {:success => "error"}.to_json)
    end
  end

  api :patch, "trips/:id"
  param :trip, Hash, :desc => "Params for details of a listing" do
    param :trip_name, String, :desc => "Name of trip"
    param :photo, String, :desc => "Image file of photo"
    param :description, String, :desc => "Description of trip"
    param :start, String, :desc => "start point of the trip (should be google address)"
    param :end, String, :desc => "end point of trip (should be google address)"
  end
  def update
    @trip = Trip.find(params[:id])
    if @trip.update(trip_params)
      render(json: {:success => "success"}.to_json)
    else
      render(json: {:success => "error"}.to_json)
    end
  end

  api :delete, "trips/:id"
  def destroy
    @trip = Trip.find(params[:id])
    if @trip.destroy
      render(json: {:success => "success"}.to_json)
    else
      render(json: {:success => "error"}.to_json)
    end
  end

  def trip_params
    params.require(:trip).permit(:trip_name, :photo, :description, :start, :end)
  end

end
