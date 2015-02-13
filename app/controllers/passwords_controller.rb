class PasswordsController < Devise::PasswordsController
  
  def set
    if !current_user
      @user = User.find_by_referral_code(params[:referral_code])

      # User already has a password
      if @user.encrypted_password && @user.encrypted_password != ""
        redirect_to '/users/sign_in'
      end
    else
      redirect_to '/users/edit', notice: "Please sign-in to continue"
    end
  end

  def set_password
    @user = User.find_by_referral_code(params[:referral_code])

    if @user.update(user_params)
      # Sign in the user by passing validation in case their password changed
      sign_in @user, :bypass => true

      if @user.conversations.count > 0
        redirect_to '/users/conversations'
      else
        redirect_to '/users/edit'
      end
    else
      render "set"
    end

  end

  private

  def user_params
    params.required(:user).permit(:password, :password_confirmation)
  end

end