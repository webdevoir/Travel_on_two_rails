class Api::V1::PolyLineStringsController < Api::V1::BaseController

  before_action :load_trip

  api :get, "trips/:id/poly_line"
  def index
    poly_line_full = { "poly_lines" => [] }
    @trip.posts.each do |post|
      route = { "poly_line" => post.route.poly_line, "route_id" => post.route.id, "center_lat" => post.route.center_lat, "center_lng" => post.route.center_lng, "poi" => post.route.point_of_interests }
      poly_line_full["poly_lines"]<< route
    end
    render(json: poly_line_full.to_json)
  end


  private

  def load_trip
    @trip = Trip.find(params[:trip_id])
  end

end
