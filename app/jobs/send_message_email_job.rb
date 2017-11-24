class SendMessageEmailJob < ApplicationJob
  queue_as :default

  def perform(sender, recipient, conversation)
    UserMailer.new_message(sender, recipient, conversation).deliver_later
  end
  
end
