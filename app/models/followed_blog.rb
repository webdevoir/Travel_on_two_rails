class FollowedBlog < ApplicationRecord
  belongs_to :user
  belongs_to :blog_owner, :foreign_key => :blog_owner_id, class_name: 'User'
end
