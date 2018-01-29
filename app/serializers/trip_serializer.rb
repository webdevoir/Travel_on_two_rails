class TripSerializer < ActiveModel::Serializer
  attributes :id, :trip_name, :user_id, :photo, :total_distance, :description, :start, :end, :start_city, :start_province, :start_country, :end_city, :end_province, :end_country

  belongs_to :user
  has_many :post_groups
  has_one :donation_goal
  has_one :gear_list

  def start_city
    array = object.start.gsub(/\s+/, "").split(",")
    return array[0]
  end

  def start_province
    array = object.start.gsub(/\s+/, "").split(",")
    return array[1]
  end

  def start_country
    array = object.start.gsub(/\s+/, "").split(",")
    return array[2]
  end

  def end_city
    array = object.end.gsub(/\s+/, "").split(",")
    return array[0]
  end

  def end_province
    array = object.end.gsub(/\s+/, "").split(",")
    return array[1]
  end

  def end_country
    array = object.end.gsub(/\s+/, "").split(",")
    return array[2]
  end
end
