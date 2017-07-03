class SearchController < ApplicationController
  def search
    if params[:q].nil?
      @trips = []
    else
      @trips_and_users = Elasticsearch::Model.search(params[:q], [Trip, User]).records.to_a
      @users = seperate_trips_and_users(@trips_and_users)
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
