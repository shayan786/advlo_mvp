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

  def request_email(email)
    mail(to: email, subject: 'Your Adventure Request')
  end

  def contact_email(contact_user)
    @contact_user = contact_user
    mail(reply_to: @contact_user.email, to: 'info@advlo.com', subject: '[ATTENTION] Advlo Contact-us Submission')
  end

end
