class User < ApplicationRecord
  has_secure_password

  
  has_one :blog
  has_many :posts, through: :blog
end
