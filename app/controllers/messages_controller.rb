class MessagesController < ApplicationController

  skip_before_action :read_nav_check, only: [:index]

  before_action do
    @conversation = Conversation.find(params[:conversation_id])
  end

  def index
    @messages = @conversation.messages
    if @messages.length > 10
      @over_ten = true
      @messages = @messages[-10..-1]
    end
    if params[:m]
      @over_ten = false
      @messages = @conversation.messages
    end
    if @messages.last
      if @messages.last.user_id != current_user.id
        @messages.last.read = true;
      end
    end
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
    @message = @conversation.messages.new
  end

  def new
    @message = @conversation.messages.new
  end

  def create
    @message = @conversation.messages.new(message_params)
    @sender = @message.user
    if @sender == @conversation.sender
      @recipent = @conversation.recipient
    else
      @recipent = @conversation.sender
    end
    if @message.save
      if @recipent.email_subscribe == true
        SendMessageEmailJob.set(wait: 20.seconds).perform_later(@sender, @recipent, @conversation)
      end
      redirect_to conversation_messages_path(@conversation)
    end
  end

  def update
    @message = Message.find(params[:id])
    @user = @message.user
    if current_user
      if (current_user.id == @conversation.sender_id || current_user.id == @conversation.recipient_id) && (current_user.id != @message.user_id) && (@message.flagged != true)
        @message.flagged = true
        @message.open_offense = true
        @user.save
        if @message.save
          redirect_to conversation_messages_path(@conversation)
          flash[:notice] = "Messaged flagged, we will take a look at this as soon as we can."
        else
          redirect_to conversation_messages_path(@conversation)
          flash[:error] = "Something went wrong"
        end
      else
        redirect_to conversation_messages_path(@conversation)
        flash[:error] = "Message already flagged."
      end
    else
      redirect_to "/"
      flash[:error] = "Need to be signed in"
    end

  end

  private
  def message_params
    params.require(:message).permit(:body, :user_id)
  end

end
