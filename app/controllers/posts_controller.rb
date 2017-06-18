class PostsController < ApplicationController
  before_action :load_trip


  def new
    @post = Post.new
    1.times { @post.post_pictures.build}
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @article }
    end
  end

  def create
    @post = @trip.posts.build(post_params)

    if @post.save
      unless params[:post_pictures] == nil
        params[:post_pictures]['image'].each do |img|
          @post_picture = @post.post_pictures.create!(:picture => img)
        end
      end
      redirect_to trip_path(@trip), notice: "Your post was posted!"
    else
      raise[:error]
      render :new
    end

  end

  def show
    @post = Post.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @article }
    end
  end

  private
  def post_params
    params.require(:post).permit(:post_title, :post_content, :address1, :address2)
  end

  def post_picture_params
    params.require("0").permit(:picture)
  end


  def load_trip
    @trip = Trip.find(params[:trip_id])
  end
end
