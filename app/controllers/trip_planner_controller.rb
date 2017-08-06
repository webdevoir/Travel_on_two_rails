class TripPlannerController < ApplicationController

  def show
    @trip = Trip.find(params[:id])
    @posts = @trip.posts.sort_by {|obj| obj.day}
    @post = @posts.first
    @user = @trip.user
  end

  def fetch_post
    @post = Post.find(params[:id])
    @post_pictures = @post.post_pictures
    @user = current_user
    respond_to do |format|
      format.js
    end
  end

end
