class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def homepage
    @feat_adventures = Adventure.all
    @feat_hosts = User.all.limit(3)
  end

  def host
  end

end
