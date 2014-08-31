class ApplicationController < ActionController::Base
  include ApplicationHelper
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  after_filter :store_location

  def terms

  end

  def about

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
    # puts "session[:previous_url] => #{session[:previous_url]}"
    session[:previous_url] || '/users/edit'
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
    @feat_adventures = Adventure.approved.where(featured: true).limit(6)
    get_regions
  end


  def contact
    @contact = ContactAdvlo.create!(contact_params)

    AdvloMailer.delay.contact_email(@contact)

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
