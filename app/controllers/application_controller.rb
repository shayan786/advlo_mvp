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
    if (request.path != '/users/sign_in' &&
        request.path != '/users/password/new' &&
        request.path != '/users/sign_out' &&
        request.path != '/users/sign_up' &&
        !request.path.include?('/users/auth/facebook') &&
        !request.xhr?) # don't store ajax calls
      session[:previous_url] = request.fullpath 
    else 
      session[:previous_url] = '/users/edit'
    end
  end

  def after_sign_in_path_for(resource)
    if request.path == '/admin/login' 
      return
    end
    puts "session[:previous_url] => #{session[:previous_url]}"
    session[:previous_url] || '/users/edit'
  end

  def after_sign_out_path_for(resource)
    puts "session[:previous_url] => #{session[:previous_url]}"
    if session[:previous_url] == '/users/edit'
      root_url
    else
      session[:previous_url]
    end
  end

  def homepage
    @hero_image = HeroImage.where(region: 'Homepage').first
    @feat_adventures = Adventure.where(approved: true).order('created_at DESC').limit(6)
    @feat_hosts = User.where(is_guide: true).limit(6)

    all_cities = []
  
    region_count = Hash.new 0
    Adventure.all.each do |a|
      all_cities << a.city
    end
    all_cities.each do |elem|    
      region_count[elem] += 1
    end
    
    @regions = region_count.sort_by {|key, value| key}.take(6)
  end

  def contact
    @contact = ContactAdvlo.create!(contact_params)

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
