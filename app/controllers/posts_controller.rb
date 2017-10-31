class PostsController < ApplicationController
  before_action :load_trip
  before_filter :require_permission, only: [:create, :new, :edit, :update, :destroy]

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
    @post_group = PostGroup.where(:year => year, :month => month, :trip_id => @trip.id)

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
    distance = post_distance(@post)
    @post.distance = distance
    if distance == false
      flash[:error]
      render :new
    else
      if @post.save
        @trip.total_distance += @post.distance
        @trip.save
        # unless params[:post_pictures] == nil
        #   params[:post_pictures]['image'].each do |img|
        #     @post_picture = @post.post_pictures.create!(:picture => img)
        #   end
        # end
        redirect_to new_trip_post_post_picture_path(@trip, @post), notice: "Your post was posted!"
        else
          flash[:error]
          render :new
        end
    end
  end

  def show
    @post = Post.find(params[:id])
    @user = @trip.user
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
    old_distance = @post.distance
    if @post.update(post_params)
      @post.distance = post_distance(@post)
      @post.save
      @trip.total_distance -= old_distance
      @trip.total_distance += @post.distance
      if @trip.save
        redirect_to new_trip_post_post_picture_path(@trip, @post), notice: "Your post was posted!"
      else
        flash[:error] = "Something went wrong"
        redirect_to trip_post_group_path(@trip, @post.post_group)
      end
    else
      flash[:error] = "Something went wrong"
      redirect_to trip_post_group_path(@trip, @post.post_group)
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
    params.require(:post).permit(:post_title, :post_content, :address1, :address2, :center_lng, :center_lat)
  end

  def post_picture_params
    params.require("0").permit(:picture)
  end

  def post_distance(post)
    start_point = post.address1
    end_point = post.address2

    encoded_url = URI.encode("https://maps.googleapis.com/maps/api/distancematrix/json?origins=#{start_point}&destinations=#{end_point}&key=#{ENV['GOOGLE_MAPS_API']}")

    http_response = RestClient::Request.execute(
       :method => :get,
       :url => encoded_url,
    )
    data = JSON.parse(http_response.body)
    if data["rows"][0]["elements"][0]["distance"] == nil
      return false
    else
      distance = data["rows"][0]["elements"][0]["distance"]["text"].to_i
      return distance
    end
  end

  def load_trip
    @trip = Trip.find(params[:trip_id])
  end

  def require_permission
    if current_user != Trip.find(params[:trip_id]).user
      redirect_to root_path
    end
  end

end
