class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  rescue_from ActionController::RoutingError, with: :render_error
  protect_from_forgery with: :exception

  after_filter :store_location

  def render_error
    render '/error_404'
  end

  def terms

  end

  def store_location
    # store last url - this is needed for post-login redirect to whatever the user last visited.
    return unless request.get? 
    if request.fullpath == '/images?type=large'
      session[:previous_url] = '/users/edit'
    elsif (request.path != '/users/sign_in' &&
        request.path != '/users/password/new' &&
        request.path != '/users/sign_out' &&
        request.path != '/users/sign_up' &&
        !request.path.include?('/users/auth/facebook') &&
        !request.xhr?) # don't store ajax calls
      session[:previous_url] = request.fullpath 
    else
      session[:previous_url] = '/users/edit'
    end

    puts "store location session[:previous_url] ====>  #{session[:previous_url]}"
  end

  def after_sign_in_path_for(resource)
    puts " after_sign_in_path_for session[:previous_url] ====>  #{session[:previous_url]}"

    if request.path == '/admin/login' 
      return
    end
    session[:previous_url] || root_path
  end

  def after_sign_out_path_for(resource)
    session[:previous_url] || root_path
  end

  def homepage
    @hero_image = HeroImage.where(region: 'Homepage').first
    @feat_adventures = Adventure.where(approved: true).order('created_at DESC').limit(6)
    @feat_hosts = User.where(is_guide: true).limit(6)

    @region_images = []
    ['Boulder', 'Colorado Springs', 'Denver', 'Fort Collins', 'High Rockies', 'Southern Colorado'].each do |r|
      @region_images << HeroImage.find_by_region(r)
    end

    # we should map the ip of each user ( logged in or not ) 
    # offer local adventures for each person
    # user.current_location = request.location.city
  end

  def contact
    @contact = ContactAdvlo.create!(contact_params)

    # Mail the requester
    # AdvloMailer.delay.contact_email(@contact)
    AdvloMailer.contact_email(@contact).deliver

    if @contact.save
      respond_to do |format|
        format.js {render "contact.js", layout: false}
      end
    end
  end

  private

  def contact_params
    params.required(:contact).permit(:user_id, :email, :comments)
  end

end
