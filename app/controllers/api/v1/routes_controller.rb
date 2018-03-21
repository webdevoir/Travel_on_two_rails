class Api::V1::RoutesController < Api::V1::BaseController

  api :get, "routes/"
  param :start_route, String, :desc => "Start location of route"
  param :end_route, String, :desc => "End location of route"
  def index
    result_routes = []
    if exists(params[:start_route]) && exists(params[:end_route])
      @routes = distance_from_points(Route.all, params[:start_route], params[:end_route])
      @routes.each do |route|
        result_routes << RouteSerializer.new(route)
      end
      render(json: result_routes.to_json)
    else
      @routes = []
      render(json: result_routes.to_json)
    end
  end

  api :get, "routes/:route_id"
  def show
    route = Route.find(params[:id])
    result = RouteSerializer.new(route)
    render(json: { success: true, route: result}.to_json)
  end

  api :post, "/routes"
  param :trip_id, Integer, :desc => "Current trip id"
  param :user_id, Integer, :desc => "Current user"
  param :route, Hash, :desc => "Params for details of a post" do
    param :distance, Integer, :desc => "Distance in meters"
    param :address1, String, :desc => "Start of the post"
    param :address2, String, :desc => "End of the post"
    param :address1_lat, String, :desc => "Lat of address 1"
    param :address1_lng, String, :desc => "Lng of address 1"
    param :address2_lat, String, :desc => "Lat of address 2"
    param :address2_lng, String, :desc => "Lng of address 2"
    param :center_lng, String, :desc => "Center lng of the two points"
    param :center_lat, String, :desc => "Center lat of the two points"
    param :poly_line, String, :desc => "Encoded polyline of the route taken"
  end
  def create
    @current_user = User.find(params[:user_id])
    @route = Route.new(route_params)
    @route.distance = params[:distance].to_i/1000
    @trip = Trip.find(params[:trip_id])
    if @route.save
      @saved_route = SavedRoute.new({
        route_id: @route.id,
        user_id: @current_user.id
        })
      if @saved_route.save
        render(json: {:success => true, :route => @route, :trip => @trip}.to_json)
      else
        render(json: {:success => "error"}.to_json)
      end
    else
      render(json: {:success => "error"}.to_json)
    end
  end

  private
  def route_params
    params.require(:route).permit(:address1, :address2, :center_lng, :center_lat, :address1_lat, :address1_lng, :address2_lat, :address2_lng, :poly_line, :distance)
  end

  def exists(param)
    if param == nil || param == ""
      return false
    else
      return true
    end
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


end
