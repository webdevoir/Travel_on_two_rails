class TripPlannerController < ApplicationController
  def index
    @trip = Trip.find(3)
    @posts = @trip.posts
  end




end
