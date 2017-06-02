class PostsController < ApplicationController
  before_action :load_trip


  def new
    @post = Post.new
    @post_picture = PostPicture.new
  end

  def create
    @post = @trip.posts.build(post_params)

    if @post.save
      redirect_to trip_path(@trip), notice: "Your post was posted!"
    else
      render :new
    end
  end

  def show
    @post = Post.find(params[:id])
  end

  private
  def post_params
    params.require(:post).permit(:post_title, :post_content, :address1, :address2)
  end

  def load_trip
    @trip = Trip.find(params[:trip_id])
  end
end
