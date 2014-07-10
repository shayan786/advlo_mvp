class AdvloMailer < ActionMailer::Base
  default from: "info@advlo.com"

  def welcome_email(user)
    @user = user
    mail(to: @user.email, subject: 'Welcome to Adventure Local')
  end
end
