class SearchController < ApplicationController
  def search
    if params[:q].nil?
      @trips = []
    else
      @trips_and_users = Elasticsearch::Model.search(params[:q], [Trip, User]).records.to_a
      @trips = seperate_trips_and_users(@trips_and_users)
      if exists(params[:start]) && !(exists(params[:end]))
        @trips.each do |trip|
          if trip.start != params[:start]
            @trips.delete(trip)
          end
        end
      elsif !(exists(params[:start])) && exists(params[:end])
        @trips.each do |trip|
          if trip.end != params[:end]
            @trips.delete(trip)
          end
        end
      elsif exists(params[:start]) && exists(params[:end])
        @trips = distance_from_points(@trips, params[:start], params[:end])
      else
        true
      end
    end
  end

  def location_search
    @trips = Trip.all
    @found_trips = distance_from_points(@trips, params[:start], params[:end])
  end


  private

  def distance_from_points(trips, start, end_location)
    @found_trips = []
    @trips.in_groups_of(24, false) do |group|
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
      search_start = start
      search_end = end_location

      # first check if start search is close to one of the starting points
      http_response = RestClient::Request.execute(
         :method => :get,
         :url => "https://maps.googleapis.com/maps/api/distancematrix/json?origins=#{search_start}&destinations=#{start_points_string}&key=#{ENV['GOOGLE_MAPS_API']}",
      )
      data = JSON.parse(http_response.body)

      http_response_second = RestClient::Request.execute(
         :method => :get,
         :url => "https://maps.googleapis.com/maps/api/distancematrix/json?origins=#{search_end}&destinations=#{end_points_string}&key=#{ENV['GOOGLE_MAPS_API']}",
      )
      data_second = JSON.parse(http_response_second.body)
      data["rows"][0]["elements"].each_with_index do |distance, index|
        if distance["status"] == "ZERO_RESULTS"
          next
        elsif distance["distance"]["value"] <= 100000
          if data_second["rows"][0]["elements"][index]["status"] == "ZERO_RESULTS"
            next
          elsif data_second["rows"][0]["elements"][index]["distance"]["value"] <= 100000
            good_trips_id << trip_id_array[index]
          end
        end
      end
      good_trips_id.each do |id|
        @found_trips << Trip.find(id)
      end
    end
    return @found_trips
  end

  def seperate_trips_and_users(trips_and_users)
    trips = []
    trips_and_users.each do |trip_or_user|
      if trip_or_user.class.name == "Trip"
        # for whatever reason include? was not working here so this was next best thing
        unless trips.include? trip_or_user
          trips << trip_or_user
        end
      else
        trip_or_user.trips.each do |trip|
          unless trips.any? {|h| h.id == trip.id }
            trips << trip
          end
        end
      end
    end
    return trips
  end

  def exists(param)
    if param == nil || param == ""
      return false
    else
      return true
    end
  end

end
