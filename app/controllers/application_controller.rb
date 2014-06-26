class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def homepage
    @feat_adventures = Adventure.order('created_at DESC').limit(6)
    @feat_hosts = User.all
  end

  def host
  end

end
