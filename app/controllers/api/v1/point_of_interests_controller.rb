class Api::V1::PointOfInterestsController < Api::V1::BaseController

  api :post, "/routes/:route_id/point_of_interests"
  param :latitude, Integer, :desc => "Lat of spot"
  param :longitude, Integer, :desc => "Lng of spot"
  param :point_of_interest, Hash, :desc => "Params for details of a post" do
    param :category, String, :desc => "Type of POI"
    param :info, String, :desc => "Info text of POI"
  end
  def create
    @route = Route.find(params[:route_id])
    @point_of_interest = PointOfInterest.new(point_of_interest_params)
    @point_of_interest.latitude = params[:latitude]
    @point_of_interest.longitude = params[:longitude]
    @point_of_interest.route_id = @route.id
    if @point_of_interest.save
      render(json: {:success => true, :point_of_interest => @point_of_interest}.to_json)
    else
      render(json: {:success => false}.to_json)
    end
  end

  def destroy
    #code
  end

  private
  def point_of_interest_params
    params.require(:point_of_interest).permit(:type, :category, :info)
  end

end
