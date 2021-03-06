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
    mail(to: @user.email, subject: 'Welcome to Adventure Local', from: "founders@advlo.com")
  end

  def welcome_email_from_founder(user)
    @user = user
    mail(to: @user.email, subject: '', from: "jon@advlo.com")

    @subject = @user.get_first_name
    mail(to: @user.email, from: 'jon@advlo.com', subject: "Hey #{@subject} - thanks for joining") do |format|
      format.html { render layout: 'marketing_advlo_mail' }
      format.text
    end
  end


  def one_week_email(user)
    @user = user
    mail(to: @user.email, from: 'christopher@advlo.com', subject: "Hey #{@user.get_name_or_email} - just checking in") do |format|
      format.html { render layout: 'simple' }
      format.text
    end
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

  def unpublished_adventure_email(adventure)
    @user = adventure.users.first
    @adventure = adventure

    # Only send the email if the adventure is not published
    if !@adventure.published && @adventure.title && @adventure.title != ''
      mail(to: @user.email, from: 'founders@advlo.com', subject: "[ADVLO] : Publish your adventure!") do |format|
        format.html { render layout: 'simple_shayan' }
        format.text
      end
    end
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

    mail(to: @user.email, bcc: 'info@advlo.com', subject: '[ADVLO] : booking confirmed')
  end

  def booking_confirmation_email_host(host, adventure, reservation)
    @adventure = adventure
    @user = host
    @res_user = User.find_by_id(reservation.user_id)

    @reservation = reservation
    mail(to: @user.email, bcc: 'info@advlo.com', subject: '[ADVLO] : booking confirmed')
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

    mail(to: @host.email, bcc: 'info@advlo.com', subject: "[ADVLO] :Reservation request for: #{@adventure.title}")
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

    mail(to: @payout_user.email, subject: "[ADVLO] : Advlo Payment - Completed", bcc: 'founders@advlo.com')
  end

  def payout_failed_email(payout)
    @payout = payout
    @payout_user = User.find_by_id(payout.user_id)
    @payout_reservations = Reservation.where(processed: true).where(host_id: @payout_user.id)

    mail(to: @payout_user.email, subject: "[ADVLO] : Advlo Payment - Failed", bcc: 'founders@advlo.com')
  end

  def paypal_payment_email(payout)
    @payout = payout
    @user = User.find(payout.user_id)

    mail(to: 'info@advlo.com', subject: "[ADVLO] : Payment Completed")
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

  # ---------- AFFILIATE EMAILS ------------------------------------------------------------------------------------------------------
  def new_affiliate_email(user)
    @user = user

    mail(to: @user.email, subject: "[ADVLO] : Affiliate Program")
  end

  def blogger_affiliate_outreach(email,name)
    @name = name

    mail(to: email, from: 'shayan@advlo.com', subject: "Advlo Affiliate Program") do |format|
      format.html { render layout: 'simple_shayan' }
      format.text
    end
  end

  # ----------- SUBSCRIPTION EMAILS -------------------------------------------------------------------------------------------------

  def subscription_created(user)
    @user = user
    customer = Stripe::Customer.retrieve(user.stripe_customer_id)
    @sub = customer.subscriptions.retrieve(user.stripe_subscription_id)

    mail(to: @user.email, subject: "[ADVLO] : Subscription Confirmation")
  end

  def subscription_cancelled(user)
    @user = user
    customer = Stripe::Customer.retrieve(user.stripe_customer_id)
    @sub = customer.subscriptions.retrieve(user.stripe_subscription_id)

    mail(to: @user.email, subject: "[ADVLO] : Subscription Cancelled")
  end

  def send_monthly_subscription_email(user_id)
    @user = User.find(user_id)
    
    mail(to: @user.email, cc: 'info@advlo.com', subject: "[ADVLO] : Adventure Subscription")
  end


  # ----------- MARKETING EMAILS --------------------------------------------------------------------------------------------------
  
  def market_share_your_adventure_host(host) 
    @user = host
    @adventures = @user.adventures

    mail(to: @user.email, subject: "[ADVLO] : Sharing your adventures") do |format|
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

  def market_hawaii_move(user)
    @user = user

    mail(to: @user.email, subject: "[ADVLO] : Advlo's In Hawaii") do |format|
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

  def market_embed_feature(user)
    @user = user

    mail(to: @user.email, subject: "[ADVLO] : New Embed Feature") do |format|
      format.html { render layout: 'marketing_advlo_mail' }
      format.text
    end
  end

  def market_nearby_adventures(user)
    @user = user

    if user.email_list == true
      if !user.is_guide
        # Get location through IP
        geocode_obj = Geocoder.search(user.current_sign_in_ip)

        lat = geocode_obj[0].data['latitude']
        long = geocode_obj[0].data['longitude']

        # Other option, if that traveler has specific the categories 'liked' find those then randomly select 3
        if user.category && user.category != ''
          user_pref_categories = user.category.split(',')

          category_sql_string = ''
          user_pref_categories.each_with_index do |cat,i|
            if (i==0)
              category_sql_string = "category LIKE '%#{cat}%'"
            elsif (i > 0)
              category_sql_string = category_sql_string + " OR category LIKE '%#{cat}%'"
            end
          end

          nearby_adventures = Adventure.near([lat,long],150).approved.limit(10).order('RANDOM()').where(category_sql_string).limit(3)

        else
          # Find nearby adventures 150 miles randomly
          nearby_adventures = Adventure.near([lat,long],300).approved.limit(10).order('RANDOM()').limit(3)
        end

        @nearby_adventures = nearby_adventures

        # If there any, then send the email
        if nearby_adventures.length > 0
          mail(to: @user.email, subject: "[ADVLO] : Adventures Near You") do |format|
            format.html { render layout: 'marketing_advlo_mail' }
            format.text
          end
        end
      end
    end
    
  end

  #--------------------- OUTREACH EMAILS -----------------------------------------

  def jon_market_host_outreach(email, name, reference=nil)
    @email = email
    @reference = reference
    @name = name

    mail(to: @email, from: 'jon@advlo.com', subject: "Adventure Marketplace") do |format|
      format.html { render layout: 'simple_jon' }
      format.text
    end
  end

  def christopher_market_host_outreach(email, name, reference=nil)
    @email = email
    @reference = reference
    @name = name

    mail(to: @email, from: 'christopher@advlo.com', subject: "Adventure Marketplace") do |format|
      format.html { render layout: 'simple' }
      format.text
    end
  end

  def shayan_market_host_outreach(email, category = nil, location)
    @email = email
    @category = category
    @location = location

    mail(to: @email, from: 'shayan@advlo.com', subject: "Adventure Marketplace") do |format|
      format.html { render layout: 'simple_shayan' }
      format.text
    end
  end


  def surf_host_outreach(email, reference=nil)
    @reference = reference
    @email = email

    mail(to: @email, from: 'founders@advlo.com', subject: "Adventure Marketplace") do |format|
      format.html { render layout: 'simple' }
      format.text
    end
  end

  def market_publisher_outreach(email, reference)
    @reference = reference
    @email = email

    mail(to: @email, from: 'christopher@advlo.com',subject: "Adventure Local - partnership", cc: @cc, bcc: @bcc) do |format|
      format.html { render layout: 'simple' }
      format.text
    end
  end

  #----------------------- newsletter-signups ----------------------

  def newsletter_welcome_invite(email)
    @email = email

    # if @email.latitude != 0.0
    #   @adventures = Adventure.near([@email.latitude, @email.longitude],250).approved.limit(3).order('RANDOM()')
    # end

    @latest_blogs = Blogpost.where(state: "Published").order('created_at DESC').limit(2)

    # if !@adventures
    @adventures = Adventure.approved.where(featured: true).sample(2)
    # end

    mail(to: @email.email, subject: "[ADVLO] #{@email.category} - adventure") do |format|
      format.html { render layout: 'email_list_advlo_mail' }
      format.text
    end
  end

  #------------------------ $1000 giveaway -------------------------

  def initial_contest_outreach(user)
    @user = user

    User.all.each do |u|
      AdvloMailer.delay.initial_contest_outreach(u)
      MarketingEmail.create(user_id: u.id, title: 'initial_contest_outreach', email: u.email)
    end

    if @user.get_first_name
      mail(to: @user.email, subject: "#{@user.get_first_name.capitalize}, the Advlo $1000 giveaway is underway!", from: 'founders@advlo.com')
    else
      mail(to: @user.email, subject: "The Advlo $1000 giveaway is underway!", from: 'founders@advlo.com')
    end
  end
  
  def after_contest_entry(user)
    @user = user
    
    mail(to: @user.email, subject: "One more day before giveaway.", from: "christopher@advlo.com") do |format|
      format.html { render layout: 'marketing_advlo_mail' }
      format.text
    end
  end

  def external_contest_email(email, reference=nil)
    @reference = reference
    mail(to: email, subject: "Advlo Giveaway is underway", from: "christopher@advlo.com")
  end
end

