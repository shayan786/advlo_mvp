class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def homepage
    @feat_adventures = Adventure.order('created_at DESC').limit(5)
    @feat_hosts = User.where(is_guide: true).limit(6)
  end

  def host
  end

end
