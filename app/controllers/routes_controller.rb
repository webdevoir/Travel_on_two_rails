class RoutesController < ApplicationController

  # note params[:type] can be google, upload, or track
  def new
    @route = Route.new()
    @trip = Trip.find(params[:trip_id])
    @track_or_upload_or_google = params[:type]
  end

  def create
    @route = Route.new(route_params)
    @route.distance = params[:distance].to_i
    @trip = Trip.find(params[:trip_id])
    if @route.save
      flash[:success] = "route saved"
      redirect_to new_trip_post_path(@trip, route_id: @route.id)
    else
      flash[:error] = "something went wrong"
      redirect_to user_path(@current_user)
    end
  end

  def show
    #code
  end

  private
  def route_params
    params.require(:route).permit(:address1, :address2, :center_lng, :center_lat, :address1_lat, :address1_lng, :address2_lat, :address2_lng, :poly_line, :distance)
  end
end
