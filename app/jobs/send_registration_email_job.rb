class SendRegistrationEmailJob < ApplicationJob
  queue_as :default

  def perform(user)
    @user = user
    UserMailer.new_registration(@user).deliver_later
  end
  
end
