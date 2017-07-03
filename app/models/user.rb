require 'elasticsearch/model'

class User < ApplicationRecord

  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  mount_uploader :cover, UserCoverUploader
  mount_uploader :avatar, AvatarUploader

  has_many :trips
  has_many :purchases, foreign_key: :buyer_id


  def has_payment_info?
    braintree_customer_id
  end
end
