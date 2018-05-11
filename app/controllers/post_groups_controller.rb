class PostGroupsController < ApplicationController
  before_action :load_trip
  before_filter :require_permission, only: :update


  def show
    @trip = Trip.find(params[:trip_id])
    @post_group = PostGroup.find(params[:id])
    @posts = @post_group.posts.sort_by {|obj| obj.day}
    @post = @posts.first
    @route = @post.route
    @post_pictures = @post.post_pictures
    @user = @trip.user
    @max_post_group = max_post_group(@trip, @post_group)
    @min_post_group = min_post_group(@trip, @post_group)
    @claps = @post.claps.length
    @new_clap = Clap.new()
    if @current_user != nil
      @already_clapped = already_clapped?(@post)
    end
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
    @user = current_user
    @route = @post.route
    @claps = @post.claps.length
    @new_clap = Clap.new()
    @already_clapped = already_clapped?(@post)
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

  def already_clapped?(post)
    check = false
    @current_user.claps.each do |clap|
      if clap.post_id == post.id
        check = true
      end
    end
    return check
  end

  def max_post_group(trip, post_group)
    post_groups = trip.post_groups.sort_by {|obj| Date::MONTHNAMES.index(obj.month) && obj.year.to_i }
    index = post_groups.find_index(post_group)
    if index == post_groups.length
      return nil
    elsif post_groups == []
      return nil
    else
      max_post_group = post_groups[index+1]
      return max_post_group
    end
  end

  def min_post_group(trip, post_group)
    post_groups = trip.post_groups.sort_by {|obj| Date::MONTHNAMES.index(obj.month) && obj.year.to_i }
    index = post_groups.find_index(post_group)
    if index == 0
      return nil
    elsif post_groups == []
      return nil
    else
      min_post_group = post_groups[index-1]
      return min_post_group
    end
  end

  def require_permission
    if current_user != Trip.find(params[:trip_id]).user
      redirect_to root_path
    end
  end

end
