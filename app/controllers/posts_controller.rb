class PostsController < ApplicationController
  before_action :load_trip


  def new
    @post = Post.new
    1.times { @post.post_pictures.build}
  end

  def create
    @post = @trip.posts.build(post_params)

    params[:post][:post_pictures_attributes].each do |number|
      @post_picture = PostPicture.new
      @post_picture.picture = params[:post][:post_pictures_attributes][number][:picture]
      raise 'hit'
      if @post_picture.save
        raise 'hit'
        next
      else
        raise 'hit'
        raise[:error]
      end
    end

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
