class RoutesController < ApplicationController

  # note params[:type] can be google, upload, or track
  def new
    @route = Route.new()
    @route = route.find(params[:route_id])
    @track_or_upload_or_google = params[:type]
  end

  def index
    if exists(params[:start]) && exists(params[:end])
      @routes = distance_from_points(Route.all, params[:start], params[:end])
    else
      @routes = []
    end
  end

  def create
    @route = Route.new(route_params)
    @route.distance = params[:distance].to_i
    @route = route.find(params[:route_id])
    if @route.save
      flash[:success] = "route saved"
      redirect_to new_route_post_path(@route, route_id: @route.id)
    else
      flash[:error] = "something went wrong"
      redirect_to user_path(@current_user)
    end
  end

  def show
    @route = Route.find(params[:id])
    @saved_route = SavedRoute.new()
    @point_of_interest = PointOfInterest.new()
  end

  def fetch_pois
    @route = Route.find(params[:route_id])
    @pois = @route.point_of_interests
    render(json: { "pois" => @pois }.to_json)
  end

  private
  def route_params
    params.require(:route).permit(:address1, :address2, :center_lng, :center_lat, :address1_lat, :address1_lng, :address2_lat, :address2_lng, :poly_line, :distance)
  end

  def distance_from_points(routes, start, end_location)
    @found_routes = []
    routes.in_groups_of(24, false) do |group|
      route_id_array = []
      good_routes_id = []
      start_points_string = ""
      end_points_string = ""
      group.each do |route|
        unless route == nil
          route_id_array << route.id
          start_points_string += route.address1.gsub(" ", "+").gsub(",","") + "|"
          end_points_string += route.address2.gsub(" ", "+").gsub(",","") + "|"
        end
      end
      start_points_string = start_points_string[0..start_points_string.length - 2]
      end_points_string = end_points_string[0..end_points_string.length - 2]

      # search_start = "Richmond Hill, ON, Canada"
      # search_end = "Brossard, QC, Canada"
      search_start = start
      search_end = end_location

      # first check if start search is close to one of the starting points
      http_response = RestClient::Request.execute(
         :method => :get,
         :url => "https://maps.googleapis.com/maps/api/distancematrix/json?origins=#{search_start}&destinations=#{start_points_string}&key=#{ENV['GOOGLE_MAPS_API']}",
      )
      data = JSON.parse(http_response.body)

      http_response_second = RestClient::Request.execute(
         :method => :get,
         :url => "https://maps.googleapis.com/maps/api/distancematrix/json?origins=#{search_end}&destinations=#{end_points_string}&key=#{ENV['GOOGLE_MAPS_API']}",
      )
      data_second = JSON.parse(http_response_second.body)
      data["rows"][0]["elements"].each_with_index do |distance, index|
        if distance["status"] == "ZERO_RESULTS"
          next
        elsif distance["distance"]["value"] <= 100000
          if data_second["rows"][0]["elements"][index]["status"] == "ZERO_RESULTS"
            next
          elsif data_second["rows"][0]["elements"][index]["distance"]["value"] <= 100000
            good_routes_id << route_id_array[index]
          end
        end
      end
      good_routes_id.each do |id|
        @found_routes << Route.find(id)
      end
    end
    return @found_routes
  end

  def exists(param)
    if param == nil || param == ""
      return false
    else
      return true
    end
  end
end
