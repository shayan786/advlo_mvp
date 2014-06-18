class AdventuresController < ApplicationController

  def index
    # @adventures = Adventure.where(region: params[:region])
    @adventures = Adventure.all
    @hero_image = HeroImage.where(region: 'Colorado').last
  end

  def show
    @adventure = Adventure.find_by_slug(params[:id])
  end

  #------------------------HOST LOGIC START----------------------------

  # Method to handle hosting/creating an adventure logic as follows:
  # 1) User is not registered or logged in (i.e. no sessions exists) 
  #     => redirect to register / sign in
  # 2) User is logged in but is not an authorized guide i.e is missing vital information in their profile to be a host
  #     => redirect to edit profile with with required info.
  # 3) User is logged in and profile is setup to have
  #     => redirect to create an adventure form

  def create_prefill
    #define recursive call back url
    redirect_url = '/adventures/create_prefill'

    #add option / params to redirect url after signing in and not redirect back to homepage to the first two ifs
    if !user_signed_in?
      redirect_to new_user_session_path

    elsif user_signed_in? && !current_user.is_guide?
      redirect_to edit_user_registration_path

    else
      #All checks out with user and being a guide
      redirect_to '/adventures/create'
    end

  end

  #Show the create an Adventure Form and create a new entry for an adventure
  def create
    #insert url inject session check for current user
    if current_user.is_guide(current_user.id) == true
      @adventure = Adventure.create!(params)
    else
      redirect_to '/adventures/create_prefill'
    end
  end

  def create_postfill

  end

  #------------------------HOST LOGIC END-----------------------------

  private
  # Using a private method to encapsulate the permissible parameters is just a good pattern
  # since you'll be able to reuse the same permit list between create and update. Also, you
  # can specialize this method with per-user checking of permissible attributes.
  def appointment_params
    params.required(:adventure).permit(:title, :subtitle, :attachment)
  end
end

