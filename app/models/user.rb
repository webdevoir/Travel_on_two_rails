# require 'elasticsearch/model'

class User < ApplicationRecord

  # include Elasticsearch::Model
  # include Elasticsearch::Model::Callbacks
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, :omniauth_providers => [:stripe_connect, :google_oauth2]
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

  def self.from_omniauth(auth)
    # Either create a User record or update it based on the provider (Google) and the UID
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.token = auth.credentials.token
      user.expires = auth.credentials.expires
      user.expires_at = auth.credentials.expires_at
      user.refresh_token = auth.credentials.refresh_token
      user.email = auth.extra.raw_info.email
    end
  end

  def conversations
    Conversation.where("sender_id = ? OR recipient_id = ?", self.id, self.id)
  end

end
