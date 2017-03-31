class User < ApplicationRecord
  has_secure_password
  mount_uploader :cover, UserCoverUploader
  mount_uploader :avatar, AvatarUploader

  has_many :trips
end
