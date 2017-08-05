class Api::V1::GearListsController < Api::V1::BaseController

  before_action :load_trip

  api :post, "trips/:trip_id/gear_lists"
  param :gear_list, Hash, :desc => "gear list hash" do
    param :bike, String, :desc => "bike used on trip"
    param :tent, String, :desc => "tent used on trip"
    param :pannier, String, :desc => "pannier used on trip"
    param :other, String, :desc => "All other gear used on the trip"
  end
  def create
    @gear_list = GearList.new(gear_list_params)
    @gear_list.trip_id = @trip.id
    if @gear_list.save
      render (json: {:success => "success"}.to_json)
    else
      render (json: {:success => "error"}.to_json)
    end
  end

  def update
    @gear_list = GearList.find(params[:id])
    @gear_list.trip_id = @trip.id
    if @gear_list.update(gear_list_params)
      render (json: {:success => "success"}.to_json)
    else
      render (json: {:success => "error"}.to_json)
    end
  end

  private
  def gear_list_params
    params.require(:gear_list).permit(:bike, :pannier, :tent, :other)
  end

  def load_trip
    @trip = Trip.find(params[:trip_id])
  end

end
