class Api::V1::ConversationsController < Api::V1::BaseController

  api :get, "conversations"
  param :user_id, String, :desc => "Current user id"
  def index
    conversations = User.find(params[:user_id]).conversations

    response = { "success" => true, "conversations" => [] }

    conversations.each do |conversation|
      result = ConversationSerializer.new(conversation)
      response["conversations"] << result
    end

    render(json: response.to_json)
  end

  api :get, "conversations/:id"
  def show

    response = { "success" => true, "conversation" => [] }
    conversation = Conversation.find(params[:id])
    response["conversation"] = ConversationSerializer.new(conversation)

    render(json: response.to_json)
  end

  api :post, "conversations"
  param :sender_id, Integer, :desc => "Person creating the message id"
  param :recipient_id, Integer, :desc => "Person recieving the message id"
  def create

    if Conversation.between(params[:sender_id],params[:recipient_id]).present?
     @conversation = Conversation.between(params[:sender_id],
      params[:recipient_id]).first
    else
      @conversation = Conversation.create!(conversation_params)
    end

    render(json: {:success => "success", :conversation => @conversation}.to_json)
  end

  private
  def conversation_params
    params.permit(:sender_id, :recipient_id)
  end

end
