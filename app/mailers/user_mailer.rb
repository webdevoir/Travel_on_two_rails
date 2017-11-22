class UserMailer < ApplicationMailer
  default from: "evan.shabsove@travelontwo.com"

  def sample_email(user)
    @user = user
    mail(to: @user.email, subject: 'Sample Email')
  end

  def new_registration(user)
    @user = user
    mail(to: @user.email, subject: 'Validate your account')
  end

  def new_message(sender, recipient, conversation)
    @conversation = conversation
    @user = sender
    @recipient = recipient
    mail(to: @recipient.email, subject: "#{@user.name} Sent you a message")
  end

  def new_post_notification(follower, user, trip, post)
    @post_group = post.post_group
    @trip = trip
    @user = user
    @follower = follower.user
    mail(to: @follower.email, subject: "#{@user.name} Made a new post")
  end

end
