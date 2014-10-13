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
    mail(to: @user.email, subject: 'Welcome to ADVLO')
  end

  # HOST EMAILS:---------------------------------------------------------------------------------------------------------------------

  def adventure_publish_request(adventure)
    @adventure = adventure
    mail(to: 'info@advlo.com', subject: '[ADVLO] : Adventure Approval Request')
  end

  def adventure_published_submitted(adventure)
    @adventure = adventure
    mail(to: @adventure.users.first.email, subject: '[ADVLO] : Your Adventure is submitted for Approval')
  end

  def adventure_approval_accepted(adventure)
    @adventure = adventure
    mail(to: @adventure.users.first.email, subject: '[ADVLO] : Your Adventure has been approved!')
  end

  # INFORMATIONAL & REQUESTS:---------------------------------------------------------------------------------------------------------------------

  def request_adventure_email(request, receiver)
    @request = request
    @receiver = receiver
    locations = @request.category.gsub(',',' & ')

    mail(to: @receiver, subject: "[ADVLO] : Request for #{locations}")
  end

  # CONVERSATIONS & MESSAGES: ---------------------------------------------------------------------------------------------------------------------

  def new_message_email(conversation, message)
    @conversation = conversation
    @message = message
    @sender = User.find_by_id(message.sender_id)

    if message.sender_id == conversation.sender_id
      @receiver = User.find_by_id(conversation.receiver_id)
    else
      @receiver = User.find_by_id(conversation.sender_id)
    end

    mail(from: 'info@advlo.com', to: @receiver.email, bcc:'info@advlo.com', subject: "[ADVLO] : Private message from: #{@sender.get_abbreviated_name_or_email}")
  end

  # -- BOOKING && REQUEST BOOKING EMAILS ------------------------------------------------------------------------------------------------------------ 

  def booking_confirmation_email_user(user, adventure, reservation)
    @adventure = adventure
    @user = user
    @reservation = reservation

    mail(to: @user.email, subject: '[ADVLO] : booking confirmed')
  end

  def booking_confirmation_email_host(host, adventure, reservation)
    @adventure = adventure
    @user = host
    @res_user = User.find_by_id(reservation.user_id)

    @reservation = reservation
    mail(to: @user.email, subject: '[ADVLO] : booking confirmed')
  end

  def booking_request_email_user(reservation)
    @reservation = reservation
    @user = User.find(reservation.user_id)
    @host = User.find(reservation.host_id)
    @adventure = Adventure.find(reservation.adventure_id)


    mail(to: @user.email, bcc: 'info@advlo.com', subject: "[ADVLO] :You Requested: #{@adventure.title}")
  end

  def booking_request_email_host(reservation)
    @user = User.find(reservation.user_id)
    @reservation = reservation
    @host = User.find(reservation.host_id)
    @adventure = Adventure.find(reservation.adventure_id)

    mail(to: @host.email, subject: "[ADVLO] :Reservation request for: #{@adventure.title}")
  end

  def booking_request_email_rejection(reservation)
    @user = User.find(reservation.user_id)
    @reservation = reservation
    @host = User.find(reservation.host_id)
    @adventure = Adventure.find(reservation.adventure_id)

    mail(to: @user.email, subject: "[ADVLO] :Booking Declined: #{@adventure.title}")
  end

  # ------ CANCELLATION EMAILS ------------------------------------------------------------------------------------------------------------
  def host_cancel_email_to_users(reservation)
    @user = User.find_by_id(reservation.user_id)
    @reservation = reservation
    @host = User.find(reservation.host_id)
    @adventure = Adventure.find(reservation.adventure_id)

    mail(to: @user.email, subject: "[ADVLO] :Booking cancellation for: #{@adventure.title}")
  end

  def host_cancel_email_to_self(reservation)
    @user = User.find(reservation.user_id)
    @reservation = reservation
    @host = User.find(reservation.host_id)
    @adventure = Adventure.find(reservation.adventure_id)

    if @reservation.event_id
      @event = Event.find_by_id(reservation.event_id)
    end

    mail(to: @host.email, bcc: "info@advlo.com", subject: "[ADVLO] :Booking cancellation for: #{@adventure.title}")
  end

  def user_cancel_email_to_host(reservation)
    @user = User.find(reservation.user_id)
    @reservation = reservation
    @host = User.find(reservation.host_id)
    @adventure = Adventure.find(reservation.adventure_id)

    mail(to: @host.email, bcc: "info@advlo.com", subject: "[ADVLO] : Booking cancellation for: #{@adventure.title}")
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
    mail(reply_to: @contact_user.email, to: 'info@advlo.com', subject: '[ADVLO] : Advlo Contact-us Submission')
  end

  # ------ PAYOUT EMAILS ------------------------------------------------------------------------------------------------------------
  def payout_completed_email(payout)
    @payout = payout
    @payout_user = User.find_by_id(@payout.user_id)
    @payout_reservations = Reservation.where(processed: true).where(host_id: @payout_user.id)

    mail(to: @payout_user.email, subject: "[ADVLO] : Advlo Payment - Completed")
  end

  def payout_failed_email(payout)
    @payout = payout
    @payout_user = User.find_by_id(payout.user_id)
    @payout_reservations = Reservation.where(processed: true).where(host_id: @payout_user.id)

    mail(to: @payout_user.email, subject: "[ADVLO] : Advlo Payment - Failed")
  end

  def paypal_payment_email(payment_url)
    @payment_url = payment_url

    mail(to: 'info@advlo.com', subject: "PAYPAL PAYMENT REQUIRED")
  end


  # ---------- REFERRAL EMAIL ------------------------------------------------------------------------------------------------------

  def send_referral_congrats(user)
    @user = user
    @referrals = User.where(referrer_id: user.id)

    mail(to: @user.email, subject: "[ADVLO] : Advlo Team - Your 25$")
  end

  def send_25_credit(user)
    @user = user
    @referrals = User.where(referrer_id: user.id)

    mail(to: @user.email, subject: "[ADVLO] : Advlo Team - Your 25$")
  end

  def marketing_referral(email)
    email = email
    mail(to: email, subject: "[ADVLO] : Travel Fund")
  end


  # ----------- SUBSCRIPTION EMAILS -------------------------------------------------------------------------------------------------

  def subscription_created(user_adventure)
    @user = User.find(user_adventure.user_id)
    @adventure = Adventure.find(user_adventure.adventure_id)
    customer = Stripe::Customer.retrieve(user_adventure.stripe_customer_id)
    @sub = customer.subscriptions.retrieve(user_adventure.stripe_subscription_id)

    mail(to: @user.email, subject: "[ADVLO] : Subscription Confirmation")
  end

  def subscription_cancelled(user_adventure)
    @user = User.find(user_adventure.user_id)
    @adventure = Adventure.find(user_adventure.adventure_id)
    customer = Stripe::Customer.retrieve(user_adventure.stripe_customer_id)
    @sub = customer.subscriptions.retrieve(user_adventure.stripe_subscription_id)

    mail(to: @user.email, subject: "[ADVLO] : Subscription Cancelled")
  end


  # ----------- MARKETING EMAILS --------------------------------------------------------------------------------------------------
  
  def market_share_your_adventure_host(host) 
    @user = host
    @adventures = @user.adventures

    mail(to: @user.email, subject: "[ADVLO] : Month in Review") do |format|
      format.html { render layout: 'marketing_advlo_mail' }
      format.text
    end
  end

  def market_one_week_last_login_user(user)
    @user = user

    mail(to: @user.email, subject: "[ADVLO] : Month in Review") do |format|
      format.html { render layout: 'marketing_advlo_mail' }
      format.text
    end
  end

  def market_new_feature_messages(user)
    @user = user

    mail(to: @user.email, subject: "[ADVLO] : Some big changes") do |format|
      format.html { render layout: 'marketing_advlo_mail' }
      format.text
    end
  end

  def market_host_outreach(skill, name, location, email)
    @name = name
    @email = email
    @skill = skill
    @location = location

    mail(to: @email, subject: "[ADVLO] : Adventure Guide platform")
  end


  def market_publisher_outreach(publisher_name, publisher, email)
    @publisher_name = publisher_name
    @email = email
    @publisher = publisher

    mail(to: @email, from: 'christopher@advlo.com',subject: "Travel with Advlo - Adventure with Locals") do |format|
      format.html { render layout: 'publisher' }
      format.text
    end
  end
end
