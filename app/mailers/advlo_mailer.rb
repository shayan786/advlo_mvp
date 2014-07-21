class AdvloMailer < ActionMailer::Base
  include Roadie::Rails::Automatic
  
  default from: "info@advlo.com"
  layout 'advlo_mail'

  # USER EMAILS:
  def welcome_email(user)
    @user = user
    mail(to: @user.email, subject: 'Welcome to Adventure Local')
  end

  def booking_confirmation_email(user, adventure, reservation)
    @adventure = adventure
    @user = user
    @reservation = reservation
    @host = User.find(@reservation.host_id)

    mail(to: @user.email, subject: 'Advlo: booking confirmation')
    mail(to: @host.email, subject: 'Advlo: booking confirmation')
  end


  # HOST EMAILS:
  def adventure_approval_request(adventure)
    @adventure = adventure
    mail(to: 'info@advlo.com', subject: '[ATTENTION] Adventure Approval Request')
  end

  def adventure_approval_confirmation(adventure)
    @adventure = adventure
    mail(to: @adventure.users.first.email, subject: 'Your Adventure is sumbitted for Approval')
  end

  # INFORMATIONAL & REQUESTS:
  def request_adventure_email(request)
    mail(to: email, subject: 'Your Adventure Request')
  end

  def request_location_email(request)

  end

  # MESSAGING THE HOST FROM ANY USER // 
  # BCC ON initial mail.. figure out internal messaging
  def contact_host_email()

  end

  # -- REQUEST A BOOKING EMAILS -- 

  def booking_request_email_user(reservation)

  end

  def booking_request_email_host(reservation)

  end

  def booking_request_email_approve_user(reservation)

  end

  def booking_request_email_approve_host(reservation)

  end

  def booking_request_email_reject_user(reservation)

  end
  

  def contact_email(contact_user)
    @contact_user = contact_user
    mail(reply_to: @contact_user.email, to: 'info@advlo.com', subject: '[ATTENTION] Advlo Contact-us Submission')
  end
end
