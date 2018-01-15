class TripSerializer < ActiveModel::Serializer
  attributes :id, :trip_name, :user_id, :photo, :total_distance, :description, :start, :end

  belongs_to :user
  has_many :post_groups
  has_one :donation_goal
  has_one :gear_list
end
