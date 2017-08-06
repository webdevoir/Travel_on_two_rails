class Api::V1::MessagesController < Api::V1::BaseController

  before_action do
    @conversation = Conversation.find(params[:conversation_id])
  end

  skip_before_action :read_nav_check, only: [:index]

  api :get, "conversations/:id/messages"
  def index
    # temp
    current_user = User.find(1)
    unread_messages = Message.where(:read => false, :conversation_id => @conversation.id)
    if unread_messages.length > 0
      unread_messages.each do |message|
        if message.user_id != current_user.id
          message.read = true
          message.save
        end
      end
    end
    read_nav_check
    result = ConversationSerializer.new(@conversation)

    render(json: result.to_json)
  end

  api :post, "conversations/:id/messages"
  param :message, Hash, :desc => "Message hash" do
    param :body, String, :desc => "Containing text of the message"
    param :user_id, Integer, :desc => "User that sent the message"
  end
  def create
    @message = @conversation.messages.new(message_params)
    if @message.save
      render(json: {:success => "success"}.to_json)
    end
  end

  private
  def message_params
    params.require(:message).permit(:body, :user_id)
  end

end
