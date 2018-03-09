class Route < ApplicationRecord
  include ActiveModel::Validations

  has_many :posts
  has_many :point_of_interests
end
