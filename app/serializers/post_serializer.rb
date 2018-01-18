class PostSerializer < ActiveModel::Serializer
  attributes :id, :post_title, :post_content, :address1, :address2, :trip_id, :created_at, :updated_at, :post_group_id, :day, :distance, :center_lat, :center_lng, :full_date, :post_pictures, :poly_line, :side_bar

  has_many :post_pictures

  def full_date
    post_group = object.post_group
    return "#{post_group.year} - #{post_group.month} - #{object.day}"
  end

  def side_bar
    post_group = object.post_group
    return "#{post_group.month} #{object.day}"
  end

  def post_pictures
    post_pictures = []

    object.post_pictures.each do |post_picture|
      custom_post_picture = post_picture.attributes
      custom_post_picture["picture"] = {
        "url" => post_picture.picture.thumb.url,
        "thumb" => post_picture.picture.thumb.url
      }
      post_pictures << custom_post_picture
    end
    return post_pictures
  end
end
