class ApplicationController < ActionController::Base
  include ApplicationHelper
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  after_filter :store_location
  
  before_filter :get_poll

  def get_poll
    @poll = Poll.find_by_name('What kind of adventurer are you?')
  end

  def calculate_poll
    @poll = Poll.find_by_name('What kind of adventurer are you?')
    case params[:answer]
      when 'answer_1' then @poll.answer_1 += 1
      when 'answer_2' then @poll.answer_2 += 1
      when 'answer_3' then @poll.answer_3 += 1
    end
    @poll.save
  end

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
    
    if cookies[:referral] == 'travel-fund'
      session[:previous_url] || '/users/edit'
    else
      '/travel-fund'
    end
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
  end


  def contact
    if params[:honeypot] == ''
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
end
