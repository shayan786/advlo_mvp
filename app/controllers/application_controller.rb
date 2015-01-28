class ApplicationController < ActionController::Base
  include ApplicationHelper
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  after_filter :store_location
  before_filter :get_poll


  def giveaway
    if params[:promo_code]
      @referrer_id = User.find_by_referral_code(params[:promo_code]).id
    end
    giveaway_get_adventures_and_entries
  end

  def update_user_giveaway
    @user = User.find(params[:user_id])
    @user.sent_promotion = true
    @user.save

    AdvloMailer.delay(run_at: 1.hour.from_now).after_contest_entry(@user)

    giveaway_get_adventures_and_entries

    # mobile callback
    if params[:post_id]
      redirect_to '/giveaway'
    else
      respond_to do |format|
        format.js {render "promotion_thanks.js", layout: false}
      end
    end
  end

  def get_poll
    @poll = Poll.last
  end

  def calculate_poll
    @poll = Poll.last
    case params[:answer]
      when 'answer_1' then @poll.answer_1 += 1
      when 'answer_2' then @poll.answer_2 += 1
      when 'answer_3' then @poll.answer_3 += 1
    end
    @poll.save
    
    respond_to do |format|
      format.js {render "calculate_poll.js", layout: false}
    end
  end

  def terms

  end

  def about

  end

  def invest
    @adventures = [] 
    @adventures << Adventure.find_by_slug('speedflying-basic-pilot')
    @adventures << Adventure.find_by_slug('essential-mountain-bike-skills')
    @adventures << Adventure.find_by_slug('the-pearl-islands-adventure')
  end

  def affiliate 
    @total_sign_ups = 0
    @total_clicks = 0
    @total_reservations = 0
    @total_earned_reservations = 0

    if current_user
      if AffiliateTracker.find_by_referrer_id(current_user.id)
        @total_sign_ups = AffiliateTracker.find_by_referrer_id(current_user.id).sign_ups
      end

      if AffiliateTracker.find_by_referrer_id(current_user.id)
        @total_clicks = AffiliateTracker.find_by_referrer_id(current_user.id).clicks
      end


      all_reservations = Reservation.where(cancelled: false).where(processed: true)

      all_reservations.each do |res|
        traveler = User.find(res.user_id)

        if current_user.id == traveler.referrer_id
          @total_earned_reservations = @total_earned_reservations + ((res.total_price - res.user_fee)*0.05)
          @total_reservations = @total_reservations + 1
        end
      end
    end

  end

  def store_location
    # store last url - this is needed for post-login redirect to whatever the user last visited.
    return unless request.get? 
    if (request.path != '/users/sign_in' &&
        request.path != '/users/password/new' &&
        request.path != '/users/sign_out' &&
        request.path != '/users/sign_up' &&
        !request.path.include?('/users/password/edit') &&
        !request.path.include?('/users/auth/facebook') &&
        !request.xhr?) # don't store ajax calls
      session[:previous_url] = request.fullpath 
    else 
      if session[:previous_url] != '/users/sign_in' && session[:previous_url] != '/users/sign_up'
        session[:previous_previous_url] = session[:previous_url]
      else
        session[:previous_url] = '/'
      end
    end
  end

  def after_sign_in_path_for(resource)
    if request.path == '/admin/login' 
      return
    end

    session[:previous_url]
  end

  def after_sign_out_path_for(resource)
    if session[:previous_url] == '/users/edit'
      root_url
    elsif session[:previous_url]
      session[:previous_url]
    else
      root_url
    end
  end

  def homepage
    @hero_image = HeroImage.where(region: 'Homepage').first
    @feat_adventures = Adventure.approved.where(featured: true).limit(6).order('CREATED_AT desc')
    @new_adventures = Adventure.approved.order('CREATED_AT desc').limit(3)
    get_regions

    if current_user
     conversations = Conversation.where('sender_id = ? OR receiver_id = ?',current_user.id,current_user.id)
     count = 0

      conversations.each do |con|
        if con.messages.last.read == false
          count += 1
        end
      end

      @messages_count = count
    end

  end


  def contact
    if params[:honeypot] == '' || params[:honeypot] == nil
      @contact = ContactAdvlo.create!(contact_params)
      AdvloMailer.delay.contact_email(@contact)
      if @contact.save
        respond_to do |format|
          if params[:about_us] == 'true'
            format.js {render "contact_from_about.js", layout: false}
          else
            format.js {render "contact.js", layout: false}
          end
        end
      end
    else
      redirect_to :back
    end
  end

  private

  def contact_params
    params.required(:contact).permit(:user_id, :email, :comments)
  end

  def giveaway_get_adventures_and_entries
    # SHOW nearby (250mi) adventures where price is > $49 && atleast 6
    # OR
    # SHOW defautl 6 adventures

    # DEFAULT ADVENTURES
    default_adventures = [] 
    default_adventures << Adventure.find_by_slug('speedflying-basic-pilot')
    default_adventures << Adventure.find_by_slug('spearfishing-in-hawaii')
    default_adventures << Adventure.find_by_slug('speed-flying-intro-course')
    default_adventures << Adventure.find_by_slug('montanita-custom-5-day-surf-lesson')
    default_adventures << Adventure.find_by_slug('andes-&-amazon-multisport-8-days')
    default_adventures << Adventure.find_by_slug('kitesurfing-in-south-africa')

    # ENABLE ON PRODUCTION
    if current_user
      user_geocode_info = current_user.get_user_geocode_info

      nearby_adventures = Adventure.near([user_geocode_info['lat'],user_geocode_info['long']],250).where("price > ?",49.to_i).approved.order('RANDOM()')

      if nearby_adventures.length > 5
        @adventures = nearby_adventures.limit(6).order('RANDOM()')
      elsif nearby_adventures == 3
        @adventures = nearby_adventures
        @adventures << default_adventures.limit(3)
      else
        @adventures = default_adventures
      end

    else
      @adventures = default_adventures
    end

    # Number of user entries
    if current_user && current_user.sent_promotion

      @user_entries = current_user.referral_count + 1

    else
      @user_entries = 0
    end

    # Total entries
    @total_entries = User.where(sent_promotion: true).count

    all_users = User.all

    all_users.each do |user|
      @total_entries+=user.referral_count
    end
  end
end
