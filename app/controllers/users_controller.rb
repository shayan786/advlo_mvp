class UsersController < ApplicationController

  def index
    @user = User.all
  end

  def show
    @user = User.find(params[:id])

    @user_languages = @user.language ? @user.language.split(',') : ['']
    @user_skillsets = @user.skillset ? @user.skillset.split(',') : ['']

    @banner_image = HeroImage.where(user_id: @user.id).first

    @reviews = Review.where(host_id: @user.id)
  end

  def update_profile_img
    @user = User.find_by_id(params[:user_id])
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


  # Just email for now
  def contact_traveler
    reservation = Reservation.find_by_id(params[:contact_traveler][:res_id])

    # Mail the traveler to be messaged
    AdvloMailer.delay.contact_traveler_email(reservation, params[:contact_traveler][:message])

    respond_to do |format|
      format.js {render "contact_traveler.js", layout: false}
    end
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

  private 

  def contact_host_params
    params.required(:contact_host).permit(:user_id, :host_id, :message, :email)
  end

  def hero_image_params
    params.required(:hero_image).permit(:user_id, :attachment)
  end

end

