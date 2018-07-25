class ConversationSerializer < ActiveModel::Serializer
  attributes :id, :sender_id, :recipient_id, :created_at, :updated_at, :sender_name, :sender_image, :recipient_name, :recipient_image, :last_message

  belongs_to :sender, :foreign_key => :sender_id, class_name: 'User'
  belongs_to :recipient, :foreign_key => :recipient_id, class_name: 'User'

  has_many :messages, dependent: :destroy

  def sender_name
    User.find(object.sender_id).name
  end

  def sender_image
    User.find(object.sender_id).avatar
  end

  def recipient_name
    User.find(object.recipient_id).name
  end

  def recipient_image
    User.find(object.recipient_id).avatar
  end

  def last_message
    if object.messages.last == nil
      return ""
    else
      last_message = object.messages.last.body
      if last_message.length >= 14
        return "#{last_message[0..12]}..."
      else
        return last_message
      end
    end
  end
end
