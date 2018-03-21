class RouteSerializer < ActiveModel::Serializer
  attributes :id, :address1, :address2, :created_at, :updated_at, :distance, :center_lat, :center_lng, :poly_line, :address1_lat, :address1_lng, :address2_lat, :address2_lng

  has_many :posts
  has_many :point_of_interests

end
