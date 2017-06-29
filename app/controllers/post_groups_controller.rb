class PostGroupsController < ApplicationController
  before_action :load_trip
  def show
    @post_group = PostGroup.find(params[:id])
    @posts = @post_group.posts.sort_by {|obj| obj.day}
    @post = @posts.first
    @post_pictures = @post.post_pictures
    @user = @trip.user
    @max_post_group = max_post_group(@trip, @post_group)
    @min_post_group = min_post_group(@trip, @post_group)
  end

  def update
    @post_group = PostGroup.find(params[:id])
    if @post_group.update_attributes(post_group_params)
      redirect_to trip_path(@trip)
    else
      flash[:error] = "Something went wrong"
      redirect_to trip_path(@trip)
    end
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

  def post_group_params
    params.require(:post_group).permit(:month, :year, :image)
  end

  def max_post_group(trip, post_group)
    post_groups = trip.post_groups
    index = post_groups.find_index(post_group)
    if index == post_groups.length
      return nil
    else
      max_post_group = post_groups[index+1]
      return max_post_group
    end
  end

  def min_post_group(trip, post_group)
    post_groups = trip.post_groups
    index = post_groups.find_index(post_group)
    if index == 0
      return nil
    else
      min_post_group = post_groups[index-1]
      return min_post_group
    end
  end
end
