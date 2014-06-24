class AdventuresController < ApplicationController

  def index
    # @adventures = Adventure.where(region: params[:region])
    @adventures = Adventure.all
    @hero_image = HeroImage.where(region: 'Colorado').last
  end

  def show
    @adventure = Adventure.find_by_slug(params[:id])
  end

  # info page for creating a new adventure
  def hosting_info
  end

  # info page for requesting a certain adventure
  def request_info
  end

  #------------------------HOST LOGIC START----------------------------

  # Method to handle hosting/creating an adventure logic as follows:
  # 1) User is not registered or logged in (i.e. no sessions exists) 
  #     => redirect to register / sign in
  # 2) User is logged in but is not an authorized guide i.e is missing vital information in their profile to be a host
  #     => redirect to edit profile with with required info.
  # 3) User is logged in and profile is setup to host but has never hosted before
  #     => redirect to create an adventure info. page
  # 4) User is logged in and profile is setup to host and has hosted before
  #     => redirect to create an adventure form

  def create_prefill
    #define recursive call back url
    #redirect_url = '/adventures/create_prefill'

    #add option / params to redirect url after signing in and not redirect back to homepage to the first two ifs
    
    # 1
    if !user_signed_in?
      redirect_to new_user_session_path
    # 2
    elsif user_signed_in? && !current_user.is_guide?(current_user.id)
      redirect_to '/users/edit', notice: "Please complete your profile so travelers know more about their host!"
    # 3
    elsif user_signed_in? && current_user.is_guide?(current_user.id) && !UserAdventure.where(user_id: current_user.id).present?
      redirect_to '/adventures/info'
    else 
      redirect_to '/adventures/create'
    end

  end

  #Show the create an Adventure Form and create a new entry for an adventure
  def create
    #add another check...before actually showing the form
    if !user_signed_in? || (user_signed_in? && !current_user.is_guide?(current_user.id))
      redirect_to '/adventures/create_prefill', notice: "Please complete your profile so travelers know more about their host!"
    end

    @adventure = Adventure.new
  end

  #------------------------HOST LOGIC END-----------------------------

  # Temporary....have methods for 
  def edit_basic
    if !user_signed_in? || (user_signed_in? && !current_user.is_guide?(current_user.id))
      redirect_to '/adventures/create_prefill', notice: "Please complete your profile so travelers know more about their host!"
    end
    
    @adventure = Adventure.find(params[:id])
  end

  def edit_photos

  end

  def edit_schedule

  end

  def update
    @adventure = Adventure.update(params)

    if @adventure.save
      redirect_to @adventure, notice: "Adventure was successfully updated"
    else
      redirect_to @adventure, notice: "Something did not work!"
    end

  end

  private
  # Using a private method to encapsulate the permissible parameters is just a good pattern
  # since you'll be able to reuse the same permit list between create and update. Also, you
  # can specialize this method with per-user checking of permissible attributes.
  def adventure_params
    params.required(:adventure).permit(:title, :subtitle, :attachment)
  end
end

