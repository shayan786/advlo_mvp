class UsersController < ApplicationController

  def index
    @user = User.all
  end

  def show
    @user = User.find(params[:id])

    puts "*****"
    puts @user.id
    puts @user.email
    puts @user.short_description
    puts "*****"

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
      AdvloMailer.delay.contact_host_email(@contact)

      respond_to do |format|
        format.js {render "contact_host.js", layout: false}
      end
    end
  end 

  def update_profile_img
    @user = User.find_by_id(params[:user_id])

    @user.avatar = params[:user][:avatar]
    @user.save

    respond_to do |format|
      format.js {render 'update_user_avatar_image.js', layout: false}
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

  private 

  def contact_host_params
    params.required(:contact_host).permit(:user_id, :host_id, :message, :email)
  end

  def hero_image_params
    params.required(:hero_image).permit(:user_id, :attachment)
  end

end

