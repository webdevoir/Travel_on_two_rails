require 'elasticsearch/model'

class Trip < ApplicationRecord
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  belongs_to :user
  has_many :posts
  has_many :post_groups
  has_one :donation_goal
  has_one :gear_list
  mount_uploader :photo, TripCoverUploader

end
