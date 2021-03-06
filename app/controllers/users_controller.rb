class UsersController < ApplicationController

  def index
    @user = User.all
  end

  def show
    @user = User.find(params[:id])
    @active_adventures = @user.adventures.approved

    @user_languages = @user.language ? @user.language.split(',') : ['']
    @user_skillsets = @user.skillset ? @user.skillset.split(',') : ['']

    @banner_image = HeroImage.where(user_id: @user.id).first

    @reviews = Review.where(host_id: @user.id)
  end

  # Messaging the host through the profile show page
  def contact_host
    @contact = ContactHost.create!(contact_host_params)
    if @contact.save
      # Mail the host to be messaged
      AdvloMailer.contact_host_email(@contact).deliver

      respond_to do |format|
        format.js {render "contact_host.js", layout: false}
      end
    end
  end 

  def update_profile_img

    @user = User.find_by_id(params[:user_id])

    puts params[:user][:avatar]
    @user.avatar = params[:user][:avatar]
    @user.save

    respond_to do |format|
      format.js {render 'update_user_avatar_image.js', layout: false}
    end
  end

  def upload_waiver
    user = User.find_by_id(params[:user_id])
    @adventure = Adventure.find(session[:adventure_id])

    if params[:waiver]['file'].content_type == "application/pdf"
      @waiver = Waiver.create!(title: params[:waiver][:title])
      @waiver.user_id = user.id
      @adventure.waiver_id = @waiver.id
      @adventure.save
      @waiver.file = params[:waiver][:file]

      respond_to do |format|
        if @waiver.save 
          format.html {redirect_to :back}
        end
      end

    else
      respond_to do |format|
        flash[:notice] = 'Not correct file type'
        format.html {redirect_to :back}
      end
    end
  end

  def delete_waiver
    @waiver = Waiver.find(params[:waiver_id])
    @waiver.destroy

    adventure = Adventure.find(session[:adventure_id])
    adventure.waiver_id = nil
    adventure.save

    respond_to do |format|
      format.js {render "waiver_destroy.js", layout: false}
    end
  end

  def edit_phone_number
    user = User.find_by_id(params[:user_id])
    phone_number = params[:phone_number]

    # Get Country code
    geo_results = Geocoder.search(user.location)
    country_code = geo_results[0].country_code

    # Normalize the phone number
    @n_phone_number = PhonyRails.normalize_number(phone_number,:country_code => country_code)

    # Verify its a phone number in correct format
    if !@n_phone_number.phony_formatted(:strict => true).nil?
      # Store normalized phone number
      user.update(phone_number: @n_phone_number)

      respond_to do |format|
        if params[:update]
          format.js {render "update_phone_number.js", layout: false}
        else
          format.js {render "new_phone_number.js", layout: false}
        end
      end
    else
      respond_to do |format|
        format.js {render "invalid_phone_number.js", layout: false}
      end
    end
  end

  def update_paypal_email
    user = User.find(params[:user_id])

    user.update(paypal_email: params[:paypal_email])

    respond_to do |format|
      if params[:paypal_update] == "1"
        format.js {render "paypal_update.js", layout: false}
      else
        format.js {render "paypal.js", layout: false}
      end
    end
  end

  def update_affiliate_referral_click_count
    if @affiliate_tracker = AffiliateTracker.find_by_referrer_id(params[:referrer_id])
      @affiliate_tracker.clicks = @affiliate_tracker.clicks + 1
      @affiliate_tracker.save
    else
      @affiliate_tracker = AffiliateTracker.create(referrer_id: params[:referrer_id])
      @affiliate_tracker.clicks = @affiliate_tracker.clicks + 1
      @affiliate_tracker.save
    end

    respond_to do |format|
      format.js {render json: {status: 200}}
    end
  end

  def become_an_affiliate
    user = User.find(params[:user_id])

    user.affiliate = true
    user.save

    redirect_to '/affiliate#become_affiliate'
  end

  def hero_image
    HeroImage.where(user_id: hero_image_params[:user_id]).each do |hi|
      hi.destroy
    end
    @banner_image = HeroImage.create!(hero_image_params)

    if @banner_image.save
      respond_to do |format|
        format.js {render 'update_user_banner_image.js', layout: false}
      end
    end
  end

  def invite
    if !user_signed_in?
      redirect_to '/travel-fund/04ca4b'
    end
  end


  def unsubscribe
    signature = params[:signature]

    respond_to do |format|
      format.html {redirect_to '/', notice: %Q( Unsubscribe from all emails ?  <a href="/unsubscriber/#{signature}">Yes</a> / <a href="/about">No</a> )  }
    end
  end

  def unsubscribe_email_list

    if user = User.read_access_token(params[:signature])
      user.email_list = false
      user.save

      respond_to do |format|
        format.html {redirect_to '/', notice: "If you change your mind you can fix it<a href='/users/edit'> in your profile</a>"}
      end
    else
      render text: 'Invalid link.'
    end
  end

  private 

  def contact_host_params
    params.required(:contact_host).permit(:user_id, :host_id, :message, :email)
  end

  def hero_image_params
    params.required(:hero_image).permit(:user_id, :attachment)
  end

end

