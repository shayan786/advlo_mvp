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

    mail(to: @user.email, subject: 'Advlo: booking confirmed')
    mail(to: @host.email, subject: 'Advlo: booking confirmed')
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
    @request = request
    locations = @request.category.gsub(',',' & ')

    mail(to: @request.email, subject: "Advlo Request : #{locations}")
    mail(to: "info@advlo.com", subject: "Adventure Request")
  end

  def request_location_email(location_request)
    @location_request = location_request

    puts @location_request.inspect

    mail(to: @location_request.email, subject: "Region Request: #{@location_request.location}")
    mail(to: "info@advlo.com", subject: "Region Request #{@location_request.location}")
  end

  # MESSAGING THE HOST FROM ANY USER // 
  # BCC ON initial mail.. figure out internal messaging
  def contact_host_email(contact)
    @contact = contact
    @host = User.find(@contact.host_id)
    @user = User.find(@contact.user_id)

    mail(to: @host.email, subject: "Private message from: #{@user.name}")
    mail(to: "info@advlo.com", subject: "Private Message to #{@host.name}")
  end

  # -- REQUEST A BOOKING EMAILS -- 

  def booking_request_email_user(reservation)
    @reservation = reservation
    @user = User.find(reservation.user_id)
    @host = User.find(reservation.host_id)
    @adventure = Adventure.find(reservation.adventure_id)

    mail(to: @user.email, subject: "Booking request: #{@adventure.title}")
    mail(to: 'info@advlo.com', subject: "Booking request: #{@adventure.title}")
  end

  def booking_request_email_host(reservation)
    @user = User.find(reservation.user_id)
    @reservation = reservation
    @host = User.find(reservation.host_id)
    @adventure = Adventure.find(reservation.adventure_id)

    mail(to: @host.email, subject: "Booking request for: #{@adventure.title}")
  end


  def booking_request_email_rejection(reservation)
    @user = User.find(reservation.user_id)
    @reservation = reservation
    @host = User.find(reservation.host_id)
    @adventure = Adventure.find(reservation.adventure_id)

    mail(to: @user.email, subject: "Booking request for: #{@adventure.title}")
  end
  

  def contact_email(contact_user)
    @contact_user = contact_user
    mail(reply_to: @contact_user.email, to: 'info@advlo.com', subject: '[ATTENTION] Advlo Contact-us Submission')
  end
end
