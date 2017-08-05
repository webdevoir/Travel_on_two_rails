class TripPlannerController < ApplicationController

  def show
    @trip = Trip.find(params[:id])
    @posts = @trip.posts.sort_by {|obj| obj.day}
    @post = @posts.first
    @user = @trip.user
  end

  def search
    @trips = Trip.all
    @found_trips = []
    @trips.in_groups_of(24) do |group|
      trip_id_array = []
      good_trips_id = []
      start_points_string = ""
      end_points_string = ""
      group.each do |trip|
        unless trip == nil
          trip_id_array << trip.id
          start_points_string += trip.start.gsub(" ", "+").gsub(",","") + "|"
          end_points_string += trip.end.gsub(" ", "+").gsub(",","") + "|"
        end
      end
      start_points_string = start_points_string[0..start_points_string.length - 2]
      end_points_string = end_points_string[0..end_points_string.length - 2]

      # search_start = "Richmond Hill, ON, Canada"
      # search_end = "Brossard, QC, Canada"
      search_start = params[:start]
      search_end = params[:end]

      # first check if start search is close to one of the starting points
      http_response = RestClient::Request.execute(
         :method => :get,
         :url => "https://maps.googleapis.com/maps/api/distancematrix/json?origins=#{search_start}&destinations=#{start_points_string}&key=AIzaSyAOPUyGan2qsdAXBODCGHa2TN6myWIxZFQ",
      )
      data = JSON.parse(http_response.body)
      data["rows"][0]["elements"].each do |distance|
        if distance["distance"]["value"] <= 100000
          http_response_second = RestClient::Request.execute(
             :method => :get,
             :url => "https://maps.googleapis.com/maps/api/distancematrix/json?origins=#{search_end}&destinations=#{end_points_string}&key=AIzaSyAOPUyGan2qsdAXBODCGHa2TN6myWIxZFQ",
          )
          data_second = JSON.parse(http_response_second.body)
          data["rows"][0]["elements"].each_with_index do |distance, index|
            if distance["distance"]["value"] <= 100000
              good_trips_id << trip_id_array[index]
            end
          end
        end
      end
      good_trips_id.each do |id|
        @found_trips << Trip.find(id)
      end
    end
  end

  def fetch_post
    @post = Post.find(params[:id])
    @post_pictures = @post.post_pictures
    @user = current_user
    respond_to do |format|
      format.js
    end
  end

end
