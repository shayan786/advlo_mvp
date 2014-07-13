class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  rescue_from ActionController::RoutingError, with: :render_error
  protect_from_forgery with: :exception

  def render_error
    render '/error_404'
  end

  def homepage
    @feat_adventures = Adventure.where(approved: true).order('created_at DESC').limit(6)
    @feat_hosts = User.where(is_guide: true).limit(6)

    # we should map the ip of each user ( logged in or not ) 
    # offer local adventures for each person
    # user.current_location = request.location.city
  end

  def contact
    @contact = ContactAdvlo.create!(contact_params)

    # Mail the requester
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
