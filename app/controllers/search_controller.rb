class SearchController < ApplicationController
  def search
    if params[:q].nil?
      @trips = []
    else
      @trips = Elasticsearch::Model.search(params[:q], [Trip, User]).records.to_a
    end
  end

end
