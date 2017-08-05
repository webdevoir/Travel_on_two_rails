class Api::V1::ConversationsController < Api::V1::BaseController

  api :get, "conversations/:id"
  def show
    conversation = Conversation.find(params[:id])
    result = ConversationSerializer.new(conversation)

    render(json: result.to_json)
  end

end
