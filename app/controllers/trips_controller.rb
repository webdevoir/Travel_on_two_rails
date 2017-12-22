class TripsController < ApplicationController
  before_filter :require_permission, only: [:edit, :update, :destroy]

  def index
    @trips = Trip.all
  end

  def show
    @trip = Trip.find_by(id: params[:id])
    @start_array = @trip.start.gsub(/\s+/, "").split(",")
    @end_array = @trip.end.gsub(/\s+/, "").split(",")
    if @trip.gear_list == nil
      @gear_list = GearList.new
    else
      @gear_list = @trip.gear_list
      @gear_list_string = gear_list_string(@trip.gear_list)
    end
    @user = @trip.user
    @posts = @trip.posts
    @post_groups = post_group_arrays(@trip.post_groups)
    @donation_goal = @trip.donation_goal
    unless @donation_goal == nil
      @percent_raised = percent_raised(@donation_goal)
    end
    if @trip.blank?
      redirect_to new_trip_url
    end
  end

  def create
    @trip = Trip.new(trip_params)
    @trip.start = "#{params[:start_city]}, #{params[:start_province]}, #{params[:start_country]}"
    @trip.end = "#{params[:end_city]}, #{params[:end_province]}, #{params[:end_country]}"
    if current_user
      @trip.user_id = current_user.id
    end

    if @trip.save
      redirect_to user_path(current_user)
    else
      render :new
    end
  end

  def new
    @trip = Trip.new
  end

  def update
    @trip = Trip.find_by(id: params[:id])
    @trip.start = "#{params[:start_city]}, #{params[:start_province]}, #{params[:start_country]}"
    @trip.end = "#{params[:end_city]}, #{params[:end_province]}, #{params[:end_country]}"
    if @trip.update(trip_params)
      redirect_to trip_path(@trip)
    else
      flash[:error] = "Something went wrong"
      redirect_to trip_path(@trip)
    end
  end

  def destroy
    @trip = Trip.find_by(id: params[:id])
    @trip.destroy
    @user = current_user
    redirect_to user_path(@user)
  end

  def fetch_posts
    @trip = Trip.find(params[:trip_id])
    @posts = sort_posts(@trip)
    render(json: { "posts" => @posts, "trip" => @trip }.to_json)
  end

  private
  def trip_params
    params.require(:trip).permit(:trip_name, :photo, :description, :start, :end)
  end

  def gear_list_string(gear_list)
    string = ""
    if gear_list.bike != ""
      string << "Bike: #{gear_list.bike}, "
    end
    if gear_list.pannier != ""
      string << "Pannier: #{gear_list.pannier}, "
    end
    if gear_list.tent != ""
      string << "Tent: #{gear_list.tent}, "
    end
    if gear_list.pannier != ""
      string << "Pannier: #{gear_list.pannier}, "
    end
    if gear_list.other != ""
      string << "Other: #{gear_list.other}, "
    end
    return string
  end

  def percent_raised(donation_goal)
    raised = donation_goal.current_paid
    amount = donation_goal.amount
    percent = raised/amount
    if percent > 100
      return 100
    else
      return percent*100.0
    end
  end

  def sort_posts(trip)
    posts_array = []
    post_groups = post_group_arrays(trip.post_groups)
    post_groups.each do |year, post_group|
      post_group.each do |post_group|
        posts = post_group.posts.sort_by {|obj| obj.day}
        posts.each do |post|
          posts_array << post
        end
      end
    end
    return posts_array
  end

  def post_group_arrays(post_groups)
    year_group_hash = {}
    post_groups.each do |post_group|
      year = post_group.year
      if year_group_hash.key?(year)
        year_group_hash[year] << post_group
      else
        year_group_hash.merge!(year => [post_group])
      end
    end
    return sorted_months(year_group_hash).sort.to_h
  end

  def sorted_months(year_group_hash)
    year_group_hash.map do |year, post_groups|
      year_group_hash[year] = post_groups.sort_by {|obj| Date::MONTHNAMES.index(obj.month) }
    end
    return year_group_hash
  end

  def require_permission
    if current_user != Trip.find(params[:id]).user
      redirect_to root_path
    end
  end
end
