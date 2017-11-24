class NewPostEmailJob < ApplicationJob
  queue_as :default

  def perform(follower, user, trip, post)
    UserMailer.new_post_notification(follower, user, trip, post).deliver_later
  end
end
