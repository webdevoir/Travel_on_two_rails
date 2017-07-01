class DonationGoalsController < ApplicationController
  before_action :load_trip

  def new
    @donation_goal = DonationGoal.new
  end

  def create
    @donation_goal =  DonationGoal.new(donation_goal_params)
    @donation_goal.trip_id = @trip.id
    @donation_goal.end_date = Date.strptime(params[:donation_goal][:end_date], "%m/%d/%Y")
    if @donation_goal.save
      redirect_to trip_path(@trip)
    else
      render :new, notice: "Somethint went wrong please try again"
    end
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

  def edit
    @donation_goal = @trip.donation_goal
  end

  private

  def load_trip
    @trip = Trip.find(params[:trip_id])
  end

  def donation_goal_params
    params.require(:donation_goal).permit(:amount, :title, :description)
  end

  # TODO: add method that makes sure you're current user in fact need to do this on a handful of routes

end
