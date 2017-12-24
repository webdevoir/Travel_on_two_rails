class SendFlaggedEmailJob < ApplicationJob
  queue_as :default

  def perform()
    UserMailer.new_flagged_message().deliver_later
  end

end
