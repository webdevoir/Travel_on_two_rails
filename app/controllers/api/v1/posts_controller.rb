class Api::V1::PostsController < Api::V1::BaseController
  before_action :load_trip

  api :post, "/trips/:trip_id/posts"
  param :post, Hash, :desc => "Params for details of a post" do
    param :post_title, String, :desc => "Name of trip"
    param :post_content, String, :desc => "Image file of photo"
    param :address1, String, :desc => "Start of the post"
    param :address2, String, :desc => "End of the post"
    param :center_lng, String, :desc => "Center lng of the two points"
    param :center_lat, String, :desc => "Center lat of the two points"
    param :post_date, String, :desc => "date of the post"
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
      render(json: {:success => "error"}.to_json)
    else
      if @post.save
        @trip.total_distance += @post.distance
        @trip.save
        render(json: {:success => "success"}.to_json)
      else
        render(json: {:success => "error"}.to_json)
      end
    end
  end

  api :put, "/trips/:trip_id/posts/:id"
  param :post, Hash, :desc => "Params for details of a post" do
    param :post_title, String, :desc => "Name of trip"
    param :post_content, String, :desc => "Image file of photo"
    param :address1, String, :desc => "Start of the post"
    param :address2, String, :desc => "End of the post"
    param :center_lng, String, :desc => "Center lng of the two points"
    param :center_lat, String, :desc => "Center lat of the two points"
    param :post_date, String, :desc => "date of the post"
  end
  def update
    # TODO: Need to put in if someone changes date of post, should also maybe think about dealing with center in back end rather then front
    @post = Post.find(params[:id])
    @trip = @post.trip
    @post.distance = post_distance(@post)
    if @post.update(post_params)
      if @post.distance != post_distance(@post) && @post.distance != nil
        if @post.distance > post_distance(@post)
          diff = @post.distance - post_distance(@post)
          @trip.total_distance -= diff
          @trip.save
        elsif @post.distance == nil
        else
          diff = post_distance(@post) - @post.distance
          @trip.total_distance += diff
          @trip.save
        end
      end
      render(json: {:success => "success"}.to_json)
    else
      render(json: {:success => "error"}.to_json)
    end
  end

  api :delete, "/trips/:trip_id/posts/:id"
  def destroy
    @post = Post.find(params[:id])
    if @post.destroy
      render(json: {:success => "success"}.to_json)
    else
      render(json: {:success => "error"}.to_json)
    end
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

    http_response = RestClient::Request.execute(
       :method => :get,
       :url => "https://maps.googleapis.com/maps/api/distancematrix/json?origins=#{start_point}&destinations=#{end_point}&key=AIzaSyAOPUyGan2qsdAXBODCGHa2TN6myWIxZFQ",
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

end
