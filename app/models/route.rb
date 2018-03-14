class Route < ApplicationRecord
  include ActiveModel::Validations

  has_many :posts
  has_many :point_of_interests

  has_many :users, through: :saved_routes
  has_many :saved_routes

  def to_gpx
    coordinates = decode(self.poly_line)
    gpx = GPX::GPXFile.new
    coordinates.each do |coordinate|
      gpx.waypoints << GPX::Waypoint.new({lat: coordinate[:lat], lon: coordinate[:lng]})
    end
    gpx.to_s
  end


  def decode(polyline)
    points = []
    index = lat = lng = 0

    while index < polyline.length
      result = 1
      shift = 0
      while true
        b = polyline[index].ord - 63 - 1
        index += 1
        result += b << shift
        shift += 5
        break if b < 0x1f
      end
      lat += (result & 1) != 0 ? (~result >> 1) : (result >> 1)

      result = 1
      shift = 0
      while true
        b = polyline[index].ord - 63 - 1
        index += 1
        result += b << shift
        shift += 5
        break if b < 0x1f
      end
      lng += (result & 1) != 0 ? ~(result >> 1) : (result >> 1)

      points << {lat: lat * 1e-5, lng: lng * 1e-5}
    end

    points
  end


end
