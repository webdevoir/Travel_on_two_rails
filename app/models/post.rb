class Post < ApplicationRecord
  belongs_to :post_group
  has_many :post_pictures

  accepts_nested_attributes_for :post_pictures, allow_destroy: true
end
