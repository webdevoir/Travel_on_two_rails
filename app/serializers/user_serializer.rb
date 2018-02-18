class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :name, :description, :avatar, :cover, :country, :province, :city, :trips

  # has_many :trips
  has_many :sent_conversations, class_name: "Conversation", foreign_key: :sender_id
  has_many :recieved_conversations, class_name: "Conversation", foreign_key: :recipient_id
  has_many :followed_blogs
  has_many :blogs_followed, class_name: "FollowedBlog", foreign_key: :blog_owner_id

  def trips
    object.trips.sort_by {|obj| obj.updated_at}.reverse
  end
end
