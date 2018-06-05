class PostSerializer < ActiveModel::Serializer
  attributes :id, :post_title, :post_content, :trip_id, :created_at, :updated_at, :post_group_id, :day, :full_date, :post_pictures, :side_bar, :clap_amount, :route_id, :center_lat, :center_lng

  has_many :post_pictures
  has_many :claps
  belongs_to :route

  def full_date
    post_group = object.post_group
    return "#{object.day} #{post_group.month} #{post_group.year}".to_datetime.strftime("%d/%m/%Y")
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

  def clap_amount
    return object.claps.length
  end

  def center_lat
    if object.route
      return object.route.center_lat
    else
      return nil
    end
  end

  def center_lng
    if object.route
      return object.route.center_lng
    else
      return nil
    end
  end

end
