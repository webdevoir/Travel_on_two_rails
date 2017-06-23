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
    date = Date.strptime(params[:post][:post_date], '%m/%d/%Y')
    year = date.year
    day = date.day
    month = date.strftime("%B")
    @post_group = PostGroup.where(:year => year, :month => month)

    if @post_group.length == 0
      @post_group = PostGroup.new(:year => year, :month => month, :trip_id => @trip.id)
      if @post_group.save
        return true
      else
        flash[:error] = "Something wen't wrong try again"
      end
    end

    @post = @trip.posts.build(post_params)
    @post.post_group_id = @post_group[0].id
    @post.day = day.to_s
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
    @user = @post.trip.user
    @post_pictures = @post.post_pictures

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @article }
    end
  end

  def edit
    @post = Post.find(params[:id])
    1.times { @post.post_pictures.build}
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @article }
    end
  end

  def update
    @post = Post.find(params[:id])
    @trip = @post.trip
    if @post.update(post_params)
      unless params[:post_pictures] == nil
        params[:post_pictures]['image'].each do |img|
          @post_picture = @post.post_pictures.create!(:picture => img)
        end
      end
      redirect_to trip_post_path(@trip, @post)
    else
      flash[:error] = "Something went wrong"
      redirect_to trip_post_path(@trip, @post)
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @trip = @post.trip
    @post.destroy
    @user = current_user
    redirect_to trip_path(@trip)
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
