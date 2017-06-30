class TripsController < ApplicationController
  def index
    @trips = Trip.all
  end

  def show
    @trip = Trip.find_by(id: params[:id])
    @user = @trip.user
    @posts = @trip.posts
    @post_groups = post_group_arrays(@trip.post_groups)
    if @trip.blank?
      redirect_to new_trip_url
    end
  end

  def create
    @trip = Trip.new(trip_params)

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



  private
  def trip_params
    params.require(:trip).permit(:trip_name, :photo)
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
    return sorted_months(year_group_hash)
  end

  def sorted_months(year_group_hash)
    year_group_hash.map do |year, post_groups|
      year_group_hash[year] = post_groups.sort_by {|obj| Date::MONTHNAMES.index(obj.month) }
    end
    return year_group_hash
  end
end
