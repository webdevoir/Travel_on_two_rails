class PostPicture < ApplicationRecord
  belongs_to :post
  mount_uploader :picture, PostPicturesUploader
end
