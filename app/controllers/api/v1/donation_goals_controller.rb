class Api::V1::DonationGoalsController < Api::V1::BaseController

  before_action :load_trip

  api :post, "trips/:trip_id/donation_goals"
  param :donation_goal, Hash, :desc => "Hash for donation goal" do
    param :amount, Float, :desc => "Amount that user wishes to raise"
    param :title, String, :desc => "Title of the goal"
    param :description, String, :desc => "description of the ggoal"
  end
  def create
    @donation_goal =  DonationGoal.new(donation_goal_params)
    @donation_goal.trip_id = @trip.id
    @donation_goal.end_date = Date.strptime(params[:donation_goal][:end_date], "%m/%d/%Y")
    if @donation_goal.save
      render (json: {:success => "success"}.to_json)
    else
      render (json: {:success => "error"}.to_json)
    end
  end

  api :put, "trips/:trip_id/donation_goals/:id"
  param :donation_goal, Hash, :desc => "Hash for donation goal" do
    param :amount, Float, :desc => "Amount that user wishes to raise"
    param :title, String, :desc => "Title of the goal"
    param :description, String, :desc => "description of the ggoal"
  end
  def update
    @donation_goal = DonationGoal.find(params[:id])
    @donation_goal.update(donation_goal_params)
    @donation_goal.end_date = Date.strptime(params[:donation_goal][:end_date], "%m/%d/%Y")
    if @donation_goal.save
      redirect_to trip_path(@trip)
    else
      render :new, notice: "Somethint went wrong please try again"
    end
  end

  private

  def load_trip
    @trip = Trip.find(params[:trip_id])
  end

  def donation_goal_params
    params.require(:donation_goal).permit(:amount, :title, :description)
  end

end
