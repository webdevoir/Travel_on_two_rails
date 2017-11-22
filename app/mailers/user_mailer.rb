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

  def new_message(sender, recipent)
    @user = sender
    @recipent = recipent
    mail(to: @user.email, subject: 'Validate your account')
  end
end
