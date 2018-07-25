class PostsController < ApplicationController
  before_action :load_trip
  before_filter :require_permission, only: [:create, :new, :edit, :update, :destroy]

  def new
    @post = Post.new
    1.times { @post.post_pictures.build}
    @date_string = ""
    if params[:route_id]
      @route = Route.find(params[:route_id])
    end
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
    if params["track_gps"] == "true" || params["upload_gps"] == "true"
      if params["upload_gps"] == "true"
        track_or_upload = "upload"
      else
        track_or_upload = "track"
      end
      redirect_to trip_track_route_path(@trip, track_or_upload: track_or_upload, date: params[:post][:post_date], post_title: post_params[:post_title], post_content: post_params[:post_content], address1: post_params[:address1], address2: post_params[:address2], center_lng: post_params[:center_lng], center_lat: post_params[:center_lat], address1_lat: post_params[:address1_lat], address1_lng: post_params[:address1_lng], address2_lat: post_params[:address2_lat], address2_lng: post_params[:address2_lng])
    else
      @post_group = PostGroup.find_by(:year => year, :month => month, :trip_id => @trip.id)

      if @post_group == nil
        @post_group = PostGroup.new(:year => year, :month => month, :trip_id => @trip.id)
        @post_group.save
      end

      @post = @trip.posts.build(post_params)
      @post.post_group_id = @post_group.id
      @post.day = day.to_s
      if params[:route_id]
        @route = Route.find(params[:route_id])
        @post.route_id = @route.id
        @trip.total_distance += @route.distance
      end
      if @post.save
        @trip.save
        send_email_to_followers(@trip, @post)
        # unless params[:post_pictures] == nil
        #   params[:post_pictures]['image'].each do |img|
        #     @post_picture = @post.post_pictures.create!(:picture => img)
        #   end
        # end
        redirect_to new_trip_post_post_picture_path(@trip, @post)
      else
        flash[:error]
        render :new
      end
    end
  end

  def track_route
    @post = Post.new
    @track_or_upload = params[:track_or_upload]
    1.times { @post.post_pictures.build}
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
    @route = @post.route
    post_group = @post.post_group
    1.times { @post.post_pictures.build}
    @date_string = "#{post_group.month}, #{@post.day}, #{post_group.year}".to_date.strftime("%m/%d/%Y")
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @article }
    end
  end

  def update
    @post = Post.find(params[:id])
    @trip = @post.trip
    @post_group_old = @post.post_group
    old_distance = @post.route.distance
    date = Date.strptime(params[:post][:post_date], '%m/%d/%Y')
    year = date.year
    day = date.day
    month = date.strftime("%B")
    if @post_group_old.month != month || @post_group_old.year != year
      @post_group = PostGroup.find_by(:year => year, :month => month, :trip_id => @trip.id)
      if @post_group == nil
        @post_group = PostGroup.new(:year => year, :month => month, :trip_id => @trip.id)
        if @post_group.save
          return true
        else
          flash[:error] = "Something wen't wrong try again"
        end
      end
    else
      @post_group = @post_group_old
    end
    @post.post_group_id = @post_group.id
    if @post.update(post_params)
      distance = (params[:post][:distance].to_f/1000).round
      polyline = params[:post][:poly_line]
      @post.distance = distance
      @post.poly_line = polyline
      @post.save
      if @post_group_old.posts.length == 0
        @post_group_old.destroy
        @post_group_old.delete
      end
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
    params.require(:post).permit(:post_title, :post_content)
  end

  def post_picture_params
    params.require("0").permit(:picture)
  end

  def send_email_to_followers(trip, post)
    @trip = trip
    @user = @trip.user
    @post = post
    @user.blogs_followed.each do |follower|
      if follower.user.email_subscribe == true
        SendRegistrationEmailJob.set(wait: 20.seconds).perform_later(follower, @user, @trip, @post)
      end
    end
  end

  def post_distance(post)
    start_point = post.address1
    end_point = post.address2

    encoded_url = URI.encode("https://maps.googleapis.com/maps/api/directions/json?origin=#{start_point}&destination=#{end_point}&mode=#{params["directions_type"].downcase}&key=#{ENV['GOOGLE_MAPS_API']}")

    http_response = RestClient::Request.execute(
       :method => :get,
       :url => encoded_url,
    )
    data = JSON.parse(http_response.body)
    if data["status"] == "ZERO_RESULTS"
      return false, false
    else
      distance = data["routes"][0]["legs"][0]["distance"]["text"].to_i
      polyline = data["routes"][0]["overview_polyline"]["points"]
      return distance, polyline
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
