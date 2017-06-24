class PostGroupsController < ApplicationController
  before_action :load_trip
  def show
    @post_group = PostGroup.find(params[:id])
    @posts = @post_group.posts
    @post = @posts.first
    @post_pictures = @post.post_pictures
    @user = @trip.user
  end

  def fetch_post
    @post = Post.find(params[:id])
    @post_pictures = @post.post_pictures
    respond_to do |format|
      format.js 
    end
  end

  private
  def load_trip
    @trip = Trip.find(params[:trip_id])
  end
end
