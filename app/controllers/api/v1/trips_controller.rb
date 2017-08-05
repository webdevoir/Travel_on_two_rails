class Api::V1::TripsController < Api::V1::BaseController

  api :get, "trips/:id"
  def show
    trip = Trip.find(params[:id])
    result = TripSerializer.new(trip)

    render(json: result.to_json)
  end

end
