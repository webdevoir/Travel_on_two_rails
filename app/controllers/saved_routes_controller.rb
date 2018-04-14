class SavedRoutesController < ApplicationController


  api :get, "saved_routes/"
  param :user_id, Integer, :desc => "Current user Id"
  def index
    @saved_routes = @current_user.saved_routes
  end

  def show
    @route = Route.find(params[:id])
    @trips = @current_user.trips
    @point_of_interest = PointOfInterest.new()
  end

  def create
    @route = Route.find(params[:route_id])
    @saved_route = SavedRoute.new({
      route_id: params[:route_id],
      user_id: @current_user.id
    })
    if @saved_route.save
      redirect_to saved_route_path(@route)
    else
      redirect_to route_path(@route)
    end
  end

  def destroy
    @route = Route.find(params[:id])
    @saved_route = @current_user.saved_routes.find_by(route_id: @route.id)
    if @saved_route.destroy
      flash[:success] = "Route Deleted"
      redirect_to saved_routes_path
    else
      flash[:error] = "Route Deleted"
      redirect_to saved_routes_path
    end
  end
end
