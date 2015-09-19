class RegistrationsController < Devise::RegistrationsController

  before_filter :check_for_bots

  def check_for_bots
    if params[:honeypot] != '' && params[:honeypot] != nil
      redirect_to '/' and return
    end
  end

  # This is the default 'my adventures' page
  def dashboard
    if !current_user
      redirect_to '/users/sign_up', notice: "Lets get you started with an account"
      return
    end
  end

  def wallet
    if !current_user
      redirect_to '/users/sign_up', notice: "Lets get you started with an account"
      return
    end
    wallet_variables
  end

  def payouts
    if !current_user
      redirect_to '/users/sign_up', notice: "Lets get you started with an account"
      return
    end
    wallet_variables
  end

  def travel_fund
    @referrals = User.where(referrer_id: current_user.id)
    @code = current_user.referral_code
  end

  def reservations
    if !current_user
      redirect_to '/users/sign_up', notice: "Lets get you started with an account"
      return
    end
    wallet_variables
  end

  def conversations
    if !current_user
      redirect_to '/users/sign_in', notice: "Please sign-in or sign-up to continue"
      return
    end

    @ordered_conversations = Conversation.where('sender_id = ? OR receiver_id = ?',current_user,current_user).order('created_at DESC')
  end

  def wallet_variables
    upcoming_sql = "processed = 'false' AND event_start_time > '#{Time.now.utc}'"
    past_sql = "processed = 'true' OR event_start_time < '#{Time.now.utc}'"

    @payouts = Payout.where(user_id: current_user.id).order('created_at DESC')
    @upcoming_reservations = Reservation.where(user_id: current_user.id).where(upcoming_sql).where(cancelled: false).order('event_start_time')
    @past_reservations = Reservation.where(user_id: current_user.id).where(past_sql).where(cancelled: false).order('event_start_time')
    @host_past_reservations = Reservation.where(host_id: current_user.id).where(past_sql).where(cancelled: false).order('event_start_time')
    @host_upcoming_reservations = Reservation.where(host_id: current_user.id).where(upcoming_sql).where(cancelled: false).order('event_start_time')
    @cancelled_reservations = Reservation.where(user_id: current_user.id).where(cancelled: true).order('event_start_time')
  end

  def inital_signin_check
    @user = User.find(current_user.id)

    case params[:type]
    when "traveler"
      @user.is_guide = false
    when "local"
      @user.is_guide = true
      @user.guide_type = 'local'
    when "business"
      @user.is_guide = true
      @user.guide_type = 'business'
    end

    @user.save

    respond_to do |format|
      format.js {render "initial_signin_check.js", layout: false }
    end
  end

  def update
    @user = User.find(current_user.id)
    #successfully_updated = if needs_password?(@user, params)
    #  @user.update_with_password(devise_parameter_sanitizer.sanitize(:account_update))
    #else
      # remove the virtual current_password attribute
      # update_without_password doesn't know how to ignore it
    params[:user].delete(:current_password)
    puts "account_update_params ******************* #{account_update_params}"
    
    if params[:category]
      @user.category = params[:category].join(",")
      @user.save
    end
    
    @user.update_without_password(account_update_params)

    #if successfully_updated
    flash[:notice] = 'You updated your account successfully'
    # Sign in the user bypassing validation in case their password changed

    sign_in @user, :bypass => true
    redirect_to "/users/edit"
  end

  def partner_invite
    if user_signed_in?
      redirect_to '/', notice: "<a href='/travel-fund'> Logged in: Invite partners to Advlo to earn money</a>" 
    else
      @referrer = User.find_by_email('founders@advlo.com')
      session[:referrer_id] = @referrer.id if @referrer

      build_resource({})
      respond_with self.resource
    end
  end

  def hostel_invite
    if user_signed_in?
      redirect_to '/', notice: "<a href='/travel-fund'> Logged in: Invite partners to Advlo to earn money</a>" 
    else
      @referrer = User.find_by_email('jon@advlo.com')
      session[:referrer_id] = @referrer.id if @referrer

      build_resource({})
      respond_with self.resource
    end
  end

  def referral_sign_up
    # Make sure user is not signed up
    if params[:referral_code] == 'secret'
      @referrer = User.find_by_email('founders@advlo.com')

      session[:referrer_id] = @referrer.id if @referrer
      session[:user_credit] = 20.0
    else
      session[:referrer_id] = @referrer.id if @referrer
      session[:user_credit] = 5.0
    end
    
    if user_signed_in?
      redirect_to '/', notice: "<a href='/travel-fund'> Logged in: Invite friends to Advlo to earn money</a>" 
    else
      @referrer ||= User.find_by_referral_code(params[:referral_code])
      session[:referrer_id] = @referrer.id if @referrer

      build_resource({})
      respond_with self.resource
    end
  end

  protected

  def after_sign_up_path_for(resource)

    @user.referrer_id = session[:referrer_id]
    @user.save

    credit_amount = params[:user][:credit]
    if credit_amount
      if credit_amount.to_i > 20.0
        credit_amount = 20.0
      end
      @user.credit = credit_amount
      @user.save
    end


    if params[:user][:is_guide]
      @user.is_guide = params[:user][:is_guide]
      @user.save
    end

    if params[:user][:guide_type]
      @user.guide_type = params[:user][:guide_type]
      @user.save
    end

    if params[:user][:affiliate] == "true"
      @user.affiliate = true
      @user.save

      AdvloMailer.delay.new_affiliate_email(@user)

      return '/affiliate#become_affiliate'
    end

    # For affiliate redirect where user does not sign up through the referral_sign_up page
    # but instead signs up through regular sign_up page
    if params[:user][:referrer_id] && params[:user][:referrer_id] != ''
      @user.referrer_id = params[:user][:referrer_id]
      @user.save

      @affiliate_tracker = AffiliateTracker.find_by_referrer_id(params[:user][:referrer_id])

      if @affiliate_tracker
        @affiliate_tracker.sign_ups = @affiliate_tracker.sign_ups + 1
        @affiliate_tracker.save
      else
        @affiliate_tracker = AffiliateTracker.create(referrer_id: params[:user][:referrer_id])
        @affiliate_tracker.sign_ups = @affiliate_tracker.sign_ups + 1
        @affiliate_tracker.save
      end
    elsif params[:promo] != nil && params[:promo][:referrer_id] && params[:promo][:referrer_id] != ''

      referrer = User.find(params[:promo][:referrer_id])
      referrer.referral_count += 1
      referrer.save

      @user.referrer_id = referrer.id
      @user.save
    end
      

    if session[:referrer_id]
      User.find(session[:referrer_id]).update_referral_count
      session[:referrer_id] = nil
    end

    # session[:previous_url]
    # on first sign up kick them to profile
    '/users/edit'
  end
  # Customize Signing Up Devise Params
  #def sign_up_params
  # params.require(:user).permit(:name, :email, :location, :sex, :dob, :bio, :language, :skillset, :password, :password_confirmation)
  #end
 
  # Customize User Profile Update Devise Params
  def account_update_params
    params.require(:user).permit(:name, :email, :location, :sex, :dob, :bio, :language, :skillset, :password, :password_confirmation, :avatar, :short_description, :tw_url, :fb_url, :ta_url, :video_url, :email_list, :is_guide, :guide_type, :credit, :affiliate, :category, :category => [])
  end

  # devise override requireing password for update
  def needs_password?(user, params)
    user.email != params[:user][:email] || params[:user][:password].present?
  end
end