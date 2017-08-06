class Api::V1::ConversationsController < Api::V1::BaseController

  api :get, "conversations/:id"
  def show
    conversation = Conversation.find(params[:id])
    result = ConversationSerializer.new(conversation)

    render(json: result.to_json)
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

    render(json: {:success => "success"}.to_json)
  end

  private
  def conversation_params
    params.permit(:sender_id, :recipient_id)
  end

end
