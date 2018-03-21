class PointOfInterestsController < ApplicationController

  def create
    @route = Route.find(params[:route_id])
    @point_of_interest = PointOfInterest.new(point_of_interest_params)
    @point_of_interest.latitude = params[:latitude]
    @point_of_interest.longitude = params[:longitude]
    @point_of_interest.route_id = @route.id
    if @point_of_interest.save
      flash[:success] = "Saved POI"
      redirect_to route_path(@route)
    else
      flash[:error] = "Something went wrong"
      redirect_to route_path(@route)
    end
  end

  def destroy
    #code
  end

  private
  def point_of_interest_params
    params.require(:point_of_interest).permit(:category, :info)
  end
end
