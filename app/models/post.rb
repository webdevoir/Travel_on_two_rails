class Post < ApplicationRecord
  belongs_to :trip
  has_many :post_pictures
end
