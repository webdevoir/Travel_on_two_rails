class PostGroupsController < ApplicationController
  before_action :load_trip
  def show
    @post_group = PostGroup.find(params[:id])
    @posts = @post_group.posts
  end

  private
  def load_trip
    @trip = Trip.find(params[:trip_id])
  end
end
