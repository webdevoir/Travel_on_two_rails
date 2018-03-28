class Api::V1::SavedRoutesController < Api::V1::BaseController

  api :get, "saved_routes/"
  param :user_id, String, :desc => "Current user Id"
  def index
    @current_user = User.find(params[:user_id])
    @saved_routes = @current_user.routes
    result_routes = []
    @saved_routes.each do |route|
      result_routes << RouteSerializer.new(route)
    end
    render(json: result_routes.to_json)
  end

  api :post, "saved_routes/"
  param :user_id, Integer, :desc => "Current user Id"
  param :route_id, Integer, :desc => "Route being saved"
  def create
    @current_user = User.find(params[:user_id])
    @route = Route.find(params[:route_id])
    @saved_route = SavedRoute.new({
      route_id: params[:route_id],
      user_id: @current_user.id
    })
    if @saved_route.save
      render(json: {:success => true, :route => @route}.to_json)
    else
      render(json: {:success => "error"}.to_json)
    end
  end

end
