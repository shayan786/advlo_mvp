class AdvloMailer < ActionMailer::Base
  include Roadie::Rails::Automatic
  
  default from: "info@advlo.com"
  layout 'advlo_mail'


  # error emails 

  def geocode_limit_hit
    mail(to: 'info@advlo.com', subject: 'Geocode limit hit')
  end

  # USER EMAILS:---------------------------------------------------------------------------------------------------------------------
  def welcome_email(user)
    @user = user
    mail(to: @user.email, subject: 'Welcome to Adventure Local')
  end

  # HOST EMAILS:---------------------------------------------------------------------------------------------------------------------

  def adventure_publish_request(adventure)
    @adventure = adventure
    mail(to: 'info@advlo.com', subject: '[ADVENTURE LOCAL] : Adventure Approval Request')
  end

  def adventure_published_submitted(adventure)
    @adventure = adventure
    mail(to: @adventure.users.first.email, subject: '[ADVENTURE LOCAL] : Your Adventure is submitted for Approval')
  end

  def adventure_approval_accepted(adventure)
    @adventure = adventure
    mail(to: @adventure.users.first.email, subject: '[ADVENTURE LOCAL] : Your Adventure has been approved!')
  end

  # INFORMATIONAL & REQUESTS:---------------------------------------------------------------------------------------------------------------------

  def request_adventure_email(request, receiver)
    @request = request
    @receiver = receiver
    locations = @request.category.gsub(',',' & ')

    mail(to: @receiver, subject: "[ADVENTURE LOCAL] : Request for #{locations}")
  end

  # MESSAGING THE HOST FROM ANY USER // 
  # BCC ON initial mail.. figure out internal messaging
  def contact_host_email(contact)
    @contact = contact
    @host = User.find(@contact.host_id)
    mail(from: @contact.email, to: @host.email, bcc:'info@advlo.com', subject: "[ADVENTURE LOCAL] : Private message from: #{contact.email}")
  end

  def contact_traveler_email(reservation, message)
    @message = message
    @reservation = reservation
    @user = User.find(reservation.user_id)
    @host = User.find(reservation.host_id)
    @adventure = Adventure.find(reservation.adventure_id)

    mail(from: @host.email, to: @user.email, subject: "[ADVENTURE LOCAL] : Message regarding: #{@adventure.title}")
  end

  # -- BOOKING && REQUEST BOOKING EMAILS ------------------------------------------------------------------------------------------------------------ 

  def booking_confirmation_email_user(user, adventure, reservation)
    @adventure = adventure
    @user = user
    @reservation = reservation

    mail(to: @user.email, subject: '[ADVENTURE LOCAL] : booking confirmed')
  end

  def booking_confirmation_email_host(host, adventure, reservation)
    @adventure = adventure
    @user = host
    @res_user = User.find_by_id(reservation.user_id)

    @reservation = reservation
    mail(to: @user.email, subject: '[ADVENTURE LOCAL] : booking confirmed')
  end

  def booking_request_email_user(reservation)
    @reservation = reservation
    @user = User.find(reservation.user_id)
    @host = User.find(reservation.host_id)
    @adventure = Adventure.find(reservation.adventure_id)

    mail(to: @user.email, bcc: 'info@advlo.com', subject: "[ADVENTURE LOCAL] : You Requested: #{@adventure.title}")
  end

  def booking_request_email_host(reservation)
    @user = User.find(reservation.user_id)
    @reservation = reservation
    @host = User.find(reservation.host_id)
    @adventure = Adventure.find(reservation.adventure_id)

    mail(to: @host.email, subject: "[ADVENTURE LOCAL] : Reservation request for: #{@adventure.title}")
  end

  def booking_request_email_rejection(reservation)
    @user = User.find(reservation.user_id)
    @reservation = reservation
    @host = User.find(reservation.host_id)
    @adventure = Adventure.find(reservation.adventure_id)

    mail(to: @user.email, subject: "[ADVENTURE LOCAL] : Booking Declined: #{@adventure.title}")
  end

  # ------ CANCELLATION EMAILS ------------------------------------------------------------------------------------------------------------
  def host_cancel_email_to_users(reservation)
    @user = User.find_by_id(reservation.user_id)
    @reservation = reservation
    @host = User.find(reservation.host_id)
    @adventure = Adventure.find(reservation.adventure_id)

    mail(to: @user.email, subject: "[ADVENTURE LOCAL] : Booking cancellation for: #{@adventure.title}")
  end

  def host_cancel_email_to_self(reservation)
    @user = User.find(reservation.user_id)
    @reservation = reservation
    @host = User.find(reservation.host_id)
    @adventure = Adventure.find(reservation.adventure_id)

    if @reservation.event_id
      @event = Event.find_by_id(reservation.event_id)
    end

    mail(to: @host.email, bcc: "info@advlo.com", subject: "[ADVENTURE LOCAL] : Booking cancellation for: #{@adventure.title}")
  end

  def user_cancel_email_to_host(reservation)
    @user = User.find(reservation.user_id)
    @reservation = reservation
    @host = User.find(reservation.host_id)
    @adventure = Adventure.find(reservation.adventure_id)

    mail(to: @host.email, bcc: "info@advlo.com", subject: "[ADVENTURE LOCAL] : Booking cancellation for: #{@adventure.title}")
  end

  def user_cancel_email_to_self(reservation)
    @user = User.find(reservation.user_id)
    @reservation = reservation
    @host = User.find(reservation.host_id)
    @adventure = Adventure.find(reservation.adventure_id)

    mail(to: @user.email, subject: "Booking cancellation for: #{@adventure.title}")
  end
  

  def contact_email(contact_user)
    @contact_user = contact_user
    mail(reply_to: @contact_user.email, to: 'info@advlo.com', subject: '[ADVENTURE LOCAL] : Advlo Contact-us Submission')
  end

  # ------ PAYOUT EMAILS ------------------------------------------------------------------------------------------------------------
  def payout_completed_email(payout)
    @payout = payout
    @payout_user = User.find_by_id(@payout.user_id)
    @payout_reservations = Reservation.where(processed: true).where(host_id: @payout_user.id)

    mail(to: @payout_user.email, subject: "[ADVENTURE LOCAL] : Advlo Payment - Completed")
  end

  def payout_failed_email(payout)
    @payout = payout
    @payout_user = User.find_by_id(payout.user_id)
    @payout_reservations = Reservation.where(processed: true).where(host_id: @payout_user.id)

    mail(to: @payout_user.email, subject: "[ADVENTURE LOCAL] : Advlo Payment - Failed")
  end

  def paypal_payment_email(payment_url)
    @payment_url = payment_url

    mail(to: 'info@advlo.com', subject: "PAYPAL PAYMENT REQUIRED")
  end


  # ---------- REFERRAL EMAIL ------------------------------------------------------------------------------------------------------

  def send_referral_congrats(user)
    @user = user
    @referrals = User.where(referrer_id: user.id)

    mail(to: @user.email, subject: "[ADVENTURE LOCAL] : Advlo Team - Your 25$")
  end

  def send_25_credit(user)
    @user = user
    @referrals = User.where(referrer_id: user.id)

    mail(to: @user.email, subject: "[ADVENTURE LOCAL] : Advlo Team - Your 25$")
  end

  def marketing_referral(email)
    email = email
    mail(to: email, subject: "[ADVENTURE LOCAL] : Travel Fund")
  end


  # ----------- SUBSCRIPTION EMAILS -------------------------------------------------------------------------------------------------

  def subscription_created(user_adventure)
    @user = User.find(user_adventure.user_id)
    @adventure = Adventure.find(user_adventure.adventure_id)
    customer = Stripe::Customer.retrieve(user_adventure.stripe_customer_id)
    @sub = customer.subscriptions.retrieve(user_adventure.stripe_subscription_id)

    mail(to: @user.email, subject: "[ADVENTURE LOCAL] : Subscription Confirmation")
  end

  def subscription_cancelled(user_adventure)
    @user = User.find(user_adventure.user_id)
    @adventure = Adventure.find(user_adventure.adventure_id)
    customer = Stripe::Customer.retrieve(user_adventure.stripe_customer_id)
    @sub = customer.subscriptions.retrieve(user_adventure.stripe_subscription_id)

    mail(to: @user.email, subject: "[ADVENTURE LOCAL] : Subscription Cancelled")
  end


  # ----------- ENGAGEMENT EMAILS --------------------------------------------------------------------------------------------------
  
  def share_your_adventure(host) 
    @host = host
    @adventures = @host.adventures

    if @adventures.count == 1
      mail(to: @host.email, subject: "[ADVENTURE LOCAL] : Share Your Adventure")
    else
      mail(to: @host.email, subject: "[ADVENTURE LOCAL] : Share Your Adventures")
    end
  end

  def one_week_last_login_user(user)
    @user = user

    mail(to: @user.email, subject: "[ADVENTURE LOCAL] : We Miss You")
  end

end
