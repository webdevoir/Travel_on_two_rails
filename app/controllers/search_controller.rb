class SearchController < ApplicationController
  def search
    if params[:q].nil?
      @trips = []
    else
      @trips = Elasticsearch::Model.search(params[:q], [Trip]).records.to_a
    end
  end

end
