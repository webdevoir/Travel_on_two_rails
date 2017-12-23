class SendPardonUserEmailJob < ApplicationJob
  queue_as :default

  def perform(user, conversation)
    @user = user
    @conversation = conversation
    UserMailer.pardon_user(@user, @conversation).deliver_later
  end

end
