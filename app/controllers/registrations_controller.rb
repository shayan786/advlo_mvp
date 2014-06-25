class RegistrationsController < Devise::RegistrationsController

  # This is the default 'my adventures' page
  def dashboard

  end

  #Overide the devise update to not require the password to update user's profile
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
    #render "edit"
    #else
    #  render "edit"
    #end
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

  # check if we need password to update user data
  # ie if password or email was changed
  # extend this as needed
  def needs_password?(user, params)
    user.email != params[:user][:email] || params[:user][:password].present?
  end

end