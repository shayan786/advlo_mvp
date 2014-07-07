class AdventuresController < ApplicationController

  def index
    # @adventures = Adventure.where(region: params[:region])
    # if params[:search].present?
    # @adventures = Adventure.near(params[:search], 50, :order => :distance)
    if params[:location].present?
      @adventures =Adventure.near(params[:location], 100)

      @hero_image = HeroImage.where(region: params[:location] ).last
      @location = params[:location]
    end
    # end
  end

  def show
    @adventure = Adventure.find_by_slug(params[:id])
    @current_guide = @adventure.users.first
    @itineraries = Itinerary.where(adventure_id: @adventure.id)
    @all_adventure_events = @adventure.events.sort_by{|a| a.start_time}
    @limited_adventure_events = @adventure.events.sort_by{|a| a.start_time}.take(5)

    @reservation = Reservation.new
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
  #     => redirect to create a new adventure form

  def create_prefill
    if !user_signed_in?
      if request.path == '/adventures/info'
        redirect_to '/adventures/info'
      else
        redirect_to '/users/sign_in'
      end
    elsif user_signed_in? && !current_user.is_guide?(current_user.id)
      redirect_to '/users/edit', notice: "Please complete your profile so travelers know more about their host!"
    else 
      redirect_to '/adventures/new'
    end

  end

  def new
    #add another check...before actually showing the form
    if !user_signed_in? || (user_signed_in? && !current_user.is_guide?(current_user.id))
      redirect_to '/adventures/create_prefill', notice: "Please complete your profile so travelers know more about their host!"
    end

    @adventure = Adventure.new
  end

  #Show the create an Adventure Form and create a new entry for an adventure
  def create
    #add another check...before actually showing the form
    if !user_signed_in? || (user_signed_in? && !current_user.is_guide?(current_user.id))
      redirect_to '/adventures/create_prefill', notice: "Please complete your profile so travelers know more about their host!"
    end

    @adventure = Adventure.create!(adventure_params)

    if @adventure.save
      #associate that adventure with that adventure
      @useradventure = @adventure.user_adventures.build(user_id: current_user.id, adventure_id: @adventure.id)
      @useradventure.save

      session[:adventure_id] =  @adventure.id

      redirect_to "/adventure_steps/photos"
    else
      render :new
    end
  end

  #------------------------HOST LOGIC END-----------------------------

  def destroy 
    @adventure = Adventure.find_by_id(params[:id])

    @adventure.destroy

    redirect_to '/users/dashboard', notice: "Adventure has been deleted!"
  end

  private
  # Using a private method to encapsulate the permissible parameters is just a good pattern
  # since you'll be able to reuse the same permit list between create and update. Also, you
  # can specialize this method with per-user checking of permissible attributes.
  def adventure_params
    params.required(:adventure).permit(:title, :subtitle, :attachment, :location, :summary, :cap_min, :cap_max, :price, :price_type, :duration_num, :duration_type, :category, :other_notes, :adventure_gallery_images, :images)
  end

end

