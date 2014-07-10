class RegistrationsController < Devise::RegistrationsController

  # This is the default 'my adventures' page
  def dashboard
    if current_user && current_user.adventures.empty?
      redirect_to '/adventures/new', notice: "Create your first adventure!"
    elsif !current_user
      redirect_to '/users/sign_up', notice: "Lets get you started with an account"
      # puts request.referer ( for redirecting to reffering location)
    end
  end

  def update
    @user = User.find(current_user.id)
    #successfully_updated = if needs_password?(@user, params)
    #  @user.update_with_password(devise_parameter_sanitizer.sanitize(:account_update))
    #else
      # remove the virtual current_password attribute
      # update_without_password doesn't know how to ignore it
    params[:user].delete(:current_password)
    @user.update_without_password(account_update_params)
    #end

    #if successfully_updated
    set_flash_message :notice, :updated
    # Sign in the user bypassing validation in case their password changed

    sign_in @user, :bypass => true
    redirect_to "/users/edit"
  end

  private

  # Customize Signing Up Devise Params
  #def sign_up_params
  # params.require(:user).permit(:name, :email, :location, :sex, :dob, :bio, :language, :skillset, :password, :password_confirmation)
  #end
 
  # Customize User Profile Update Devise Params
  def account_update_params
    params.require(:user).permit(:name, :email, :location, :sex, :dob, :bio, :language, :skillset, :password, :password_confirmation, :avatar, :short_description, :tw_url, :fb_url, :li_url)
  end

  def after_sign_up_path_for(resource)
    '/users/dashboard'
  end

  # devise override requireing password for update
  def needs_password?(user, params)
    user.email != params[:user][:email] || params[:user][:password].present?
  end
end