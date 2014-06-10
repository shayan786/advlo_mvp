class UserMailer < ActionMailer::Base
  default from: "info@advlo.com"

  def welcome_email(user)
    @user = user
    # @url = 'http://localhost:3000/users/sign_in'
    mail(to: @user.email, subject: 'Welcome to Adventure Local')
  end
end
