class AdvloMailer < ActionMailer::Base
  default from: "info@advlo.com"

  def welcome_email(user)
    @user = user
    mail(to: @user.email, subject: 'Welcome to Adventure Local')
  end

  def request_email(email)
    mail(to: email, subject: 'Your Adventure Request')
  end

end
