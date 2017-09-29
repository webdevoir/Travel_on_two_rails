class PostSerializer < ActiveModel::Serializer
  attributes :id, :post_title, :post_content, :address1, :address2, :trip_id, :created_at, :updated_at, :post_group_id, :day, :distance, :center_lat, :center_lng, :full_date

  has_many :post_pictures

  def full_date
    post_group = object.post_group
    return "#{post_group.year} - #{post_group.month} - #{object.day}"
  end
end
