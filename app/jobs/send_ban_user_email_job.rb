class SendBanUserEmailJob < ApplicationJob
  queue_as :default

  def perform(user, conversation)
    @user = user
    @conversation = conversation
    UserMailer.ban_user(@user, @conversation).deliver_later
  end

end
