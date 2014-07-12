class AdvloMailer < ActionMailer::Base
  default from: "info@advlo.com"

  def adventure_approval_email(adventure)
    @adventure = adventure
    mail(to: 'ChrisKnight.mail@gmail.com', subject: 'Adventure Pending Approval')
  end

  def welcome_email(user)
    @user = user
    mail(to: @user.email, subject: 'Welcome to Adventure Local')
  end
end
