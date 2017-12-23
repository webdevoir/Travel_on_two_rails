class SendWarnUserEmailJob < ApplicationJob
  queue_as :default

  def perform(user, conversation)
    @user = user
    @conversation = conversation
    UserMailer.warn_user(@user, @conversation).deliver_later
  end

end
