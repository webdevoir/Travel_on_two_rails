class Post < ApplicationRecord

  attr_accessor :already_clapped

  include ActiveModel::Validations

  belongs_to :post_group
  belongs_to :trip
  belongs_to :route
  has_many :post_pictures
  has_many :claps

  accepts_nested_attributes_for :post_pictures, allow_destroy: true
  validates :post_title, :post_content, :day, presence: true

  def full_date
    post = self
    post_group = post.post_group
    date_string = "#{post_group.month}, #{post.day}, #{post_group.year}".to_date
  end
end
