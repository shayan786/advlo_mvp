class UserMailer < ActionMailer::Base
  default from: "info@advlo.com"

  def appointment_email(user)
    mail(to: user.email, subject: 'Thanks for joining Advlo!')
  end
end
