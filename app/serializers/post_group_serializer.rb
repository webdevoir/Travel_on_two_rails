class PostGroupSerializer < ActiveModel::Serializer
  attributes :id, :month, :year, :image, :trip_id

  has_many :posts
  belongs_to :trip
end
