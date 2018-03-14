class SavedRoutesController < ApplicationController

  def index
    @saved_routes = @current_user.routes
  end

  def show
    @route = Route.find(params[:id])
    @trips = @current_user.trips
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
    #code
  end
end
