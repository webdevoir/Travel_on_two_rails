class PostGroup < ApplicationRecord
  has_many :posts
  belongs_to :trip

  mount_uploader :image, PostGroupUploader
end
