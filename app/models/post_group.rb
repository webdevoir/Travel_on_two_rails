class PostGroup < ApplicationRecord
  has_many :posts
  belongs_to :trip
end
