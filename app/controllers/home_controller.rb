class HomeController < ApplicationController
  def index
    if current_user
      @user_id = current_user.id
    end
    trips = Trip.all
    @featured_trips = []
    3.times do
      @featured_trips << trips.sample
    end
    @feedback = Feedback.new()
  end

  def about
    @feedback = Feedback.new()
  end
end
