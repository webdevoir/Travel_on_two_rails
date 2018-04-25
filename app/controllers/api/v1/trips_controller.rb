class Api::V1::TripsController < Api::V1::BaseController

  api :get, "trips/:id"
  def show
    trip = Trip.find(params[:id])
    result = TripSerializer.new(trip)

    render(json: { success: true, trip: result }.to_json)
  end

  api :get, "trips"
  param :user_id, String, :desc => "Current User id"
  def index
    current_user = User.find(params[:user_id])
    trips = current_user.trips
    results = []
    trips.each do |trip|
      result = TripSerializer.new(trip)
      results << result
    end
    render(json: { success: true, trips: results }.to_json)
  end

  api :post, "trips"
  param :user_id, String, :desc => "Current User id"
  param :trip, Hash, :desc => "Params for details of a listing" do
    param :trip_name, String, :desc => "Name of trip"
    param :photo, String, :desc => "Image file of photo"
    param :description, String, :desc => "Description of trip"
    param :start_city, String, :desc => "start point of the trip (should be google address)"
    param :start_province, String, :desc => "start point of the trip (should be google address)"
    param :start_country, String, :desc => "start point of the trip (should be google address)"
    param :end_city, String, :desc => "start point of the trip (should be google address)"
    param :end_province, String, :desc => "start point of the trip (should be google address)"
    param :end_country, String, :desc => "start point of the trip (should be google address)"
  end
  def create
    current_user = User.find(params[:user_id])
    @user = current_user
    @trip = Trip.new(trip_params)
    @trip.user_id = @user.id
    @trip.start = "#{params[:trip][:start_city]}, #{params[:trip][:start_province]}, #{params[:trip][:start_country]}"
    @trip.end = "#{params[:trip][:end_city]}, #{params[:trip][:end_province]}, #{params[:trip][:end_country]}"
    if params[:fileName] != nil
      @trip.photo = params[:file]
    end
    if @trip.save
      render(json: {:success => true, :trip => @trip}.to_json)
    else
      render(json: {:success => "error"}.to_json)
    end
  end

  api :patch, "trips/:id"
  param :trip, Hash, :desc => "Params for details of a listing" do
    param :trip_name, String, :desc => "Name of trip"
    param :photo, String, :desc => "Image file of photo"
    param :description, String, :desc => "Description of trip"
    param :start_city, String, :desc => "start point of the trip (should be google address)"
    param :start_province, String, :desc => "start point of the trip (should be google address)"
    param :start_country, String, :desc => "start point of the trip (should be google address)"
    param :end_city, String, :desc => "start point of the trip (should be google address)"
    param :end_province, String, :desc => "start point of the trip (should be google address)"
    param :end_country, String, :desc => "start point of the trip (should be google address)"
  end
  def update
    @trip = Trip.find(params[:id])
    if params[:trip] != nil
      @trip.trip_name = params[:trip][:trip_name]
      @trip.description = params[:trip][:description]
      @trip.start = "#{params[:trip][:start_city]}, #{params[:trip][:start_province]}, #{params[:trip][:start_country]}"
      @trip.end = "#{params[:trip][:end_city]}, #{params[:trip][:end_province]}, #{params[:trip][:end_country]}"
    end
    if params[:fileName] != nil
      @trip.photo = params[:file]
    end
    if @trip.save
      render(json: {:success => true, :trip => @trip}.to_json)
    else
      render(json: {:success => "error"}.to_json)
    end
  end

  api :delete, "trips/:id"
  def destroy
    @trip = Trip.find(params[:id])
    if @trip.destroy
      render(json: {:success => true}.to_json)
    else
      render(json: {:success => "error"}.to_json)
    end
  end

  def trip_params
    params.require(:trip).permit(:trip_name, :photo, :description, :start, :end)
  end

end
