# require 'elasticsearch/model'

class User < ApplicationRecord

  # include Elasticsearch::Model
  # include Elasticsearch::Model::Callbacks
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, :omniauth_providers => [:stripe_connect]
  mount_uploader :cover, UserCoverUploader
  mount_uploader :avatar, AvatarUploader

  has_many :trips
  has_many :purchases, foreign_key: :buyer_id
  has_many :sent_conversations, class_name: "Conversation", foreign_key: :sender_id
  has_many :recieved_conversations, class_name: "Conversation", foreign_key: :recipient_id
  has_many :followed_blogs
  has_many :blogs_followed, class_name: "FollowedBlog", foreign_key: :blog_owner_id
  has_one :stripe_account
  has_many :routes, through: :saved_routes
  has_many :saved_routes
  has_many :claps


  def has_payment_info?
    braintree_customer_id
  end

  def conversations
    Conversation.where("sender_id = ? OR recipient_id = ?", self.id, self.id)
  end

end
