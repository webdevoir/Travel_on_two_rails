class SearchController < ApplicationController
  def search
    if params[:q].nil?
      @trips = []
    else
      @trips_and_users = Elasticsearch::Model.search(params[:q], [Trip, User]).records.to_a
      @users = seperate_trips_and_users(@trips_and_users)
    end
  end

  def location_search
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

      first check if start search is close to one of the starting points
      http_response = RestClient::Request.execute(
         :method => :get,
         :url => "https://maps.googleapis.com/maps/api/distancematrix/json?origins=#{search_start}&destinations=#{start_points_string}&key=#{ENV['GOOGLE_MAPS_API']}",
      )
      data = JSON.parse(http_response.body)
      data["rows"][0]["elements"].each do |distance|
        if distance["distance"]["value"] <= 100000
          http_response_second = RestClient::Request.execute(
             :method => :get,
             :url => "https://maps.googleapis.com/maps/api/distancematrix/json?origins=#{search_end}&destinations=#{end_points_string}&key=#{ENV['GOOGLE_MAPS_API']}",
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


  private

  def seperate_trips_and_users(trips_and_users)
    users = []
    trips_and_users.each do |trip_or_user|
      if trip_or_user.class.name == "Trip"
        # for whatever reason include? was not working here so this was next best thing
        unless users.any? {|h| h.id == trip_or_user.user.id }
          users << trip_or_user.user
        end
      else
        unless users.include? trip_or_user
          users << trip_or_user
        end
      end
    end
    return users
  end

end
