class DonationGoalsController < ApplicationController
  before_action :load_trip
    before_filter :require_permission, only: [:create, :new, :edit, :update, :destroy]

  def new
    @donation_goal = DonationGoal.new
    @stripe_account = @current_user.stripe_account
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

  # TODO: Make a destroy method

  private

  def load_trip
    @trip = Trip.find(params[:trip_id])
  end

  def donation_goal_params
    params.require(:donation_goal).permit(:amount, :title, :description)
  end

  def require_permission
    if current_user != Trip.find(params[:trip_id]).user
      redirect_to root_path
    end
  end

end
