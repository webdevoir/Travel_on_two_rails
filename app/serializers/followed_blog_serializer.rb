class FollowedBlogSerializer < ActiveModel::Serializer
  attributes :id, :blog_owner_id, :user_id, :updated_at, :created_at, :blog_owner_name, :blog_owner_image

  def blog_owner_name
    User.find(object.blog_owner_id).name
  end

  def blog_owner_image
    User.find(object.blog_owner_id).avatar
  end
end
