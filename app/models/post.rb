class Post < ApplicationRecord
  include ActiveModel::Validations

  belongs_to :post_group
  belongs_to :trip
  has_many :post_pictures

  accepts_nested_attributes_for :post_pictures, allow_destroy: true
  validates :post_title, :post_content, :day, presence: true
end
