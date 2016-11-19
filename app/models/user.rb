class User < ApplicationRecord
  has_one :blog
  has_many :posts, through: :blog
end
