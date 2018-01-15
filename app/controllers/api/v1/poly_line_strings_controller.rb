class Api::V1::PolyLineStringsController < Api::V1::BaseController

  before_action :load_trip

  api :get, "trips/:id/poly_line"
  def index
    poly_line_full = { "poly_line" => "" }
    @trip.posts.each do |post|
      poly_line_full["poly_line"] += post.poly_line
    end
    render(json: poly_line_full.to_json)
  end


  private

  def load_trip
    @trip = Trip.find(params[:trip_id])
  end

end
