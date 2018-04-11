class Api::V1::PointOfInterestsController < Api::V1::BaseController

  api :post, "/routes/:route_id/point_of_interests"
  param :latitude, String, :desc => "Lat of spot"
  param :longitude, String, :desc => "Lng of spot"
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


  api :post, "/routes/:route_id/point_of_interests"
  # param :all_poi, Hash, :desc => "Hash of poi objects" do
  #   param :point_of_interest, Hash, :desc => "Params for details of a post" do
  #     param :latitude, String, :desc => "Lat of spot"
  #     param :longitude, String, :desc => "Lng of spot"
  #     param :category, String, :desc => "Type of POI"
  #     param :info, String, :desc => "Info text of POI"
  #   end
  # end
  def create_many
    @route = Route.find(params[:route_id])
    params["_json"].each do |point_of_interest_array|
      point_of_interest = PointOfInterest.new({
        category: point_of_interest_array["point_of_interest"]["category"],
        info: point_of_interest_array["point_of_interest"]["info"],
        latitude: point_of_interest_array["point_of_interest"]["latitude"].to_s,
        longitude: point_of_interest_array["point_of_interest"]["longitude"].to_s,
        route_id: @route.id
      })
      binding.pry
      point_of_interest.save
    end
    render(json: {:success => true}.to_json)
  end

  def destroy
    #code
  end

  private
  def point_of_interest_params
    params.require(:point_of_interest).permit(:type, :category, :info)
  end

end
