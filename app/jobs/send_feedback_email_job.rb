class SendFeedbackEmailJob < ApplicationJob
  queue_as :default

  def perform(feedback)
    UserMailer.new_feedback(feedback).deliver_later
  end

end
