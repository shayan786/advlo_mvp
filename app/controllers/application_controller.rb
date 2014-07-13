class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  rescue_from ActionController::RoutingError, with: :render_error
  protect_from_forgery with: :exception

  def render_error
    render '/error_404'
  end

  def homepage
    @feat_adventures = Adventure.order('created_at DESC').limit(5)
    @feat_hosts = User.where(is_guide: true).limit(6)
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
