class RegistrationsController < Devise::RegistrationsController

  # This is the default 'my adventures' page
  def dashboard
    if !current_user
      redirect_to '/users/sign_up', notice: "Lets get you started with an account"
      return
    end
  end

  def wallet
    if !current_user
      redirect_to '/users/sign_up', notice: "Lets get you started with an account"
      return
    end
    wallet_variables
  end

  def payouts
    if !current_user
      redirect_to '/users/sign_up', notice: "Lets get you started with an account"
      return
    end
    wallet_variables
  end

  def reservations
    if !current_user
      redirect_to '/users/sign_up', notice: "Lets get you started with an account"
      return
    end
    wallet_variables
  end

  def wallet_variables
    upcoming_sql = "processed = 'false' AND event_start_time > '#{Time.now.utc}'"
    past_sql = "processed = 'true' OR event_start_time < '#{Time.now.utc}'"

    @payouts = Payout.where(user_id: current_user.id).order('created_at DESC')
    @upcoming_reservations = Reservation.where(user_id: current_user.id).where(upcoming_sql).where(cancelled: false).order('event_start_time')
    @past_reservations = Reservation.where(user_id: current_user.id).where(past_sql).where(cancelled: false).order('event_start_time')
    @host_past_reservations = Reservation.where(host_id: current_user.id).where(past_sql).where(cancelled: false).order('event_start_time')
    @host_upcoming_reservations = Reservation.where(host_id: current_user.id).where(upcoming_sql).where(cancelled: false).order('event_start_time')
    @cancelled_reservations = Reservation.where(user_id: current_user.id).where(cancelled: true).order('event_start_time')
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
    flash[:notice] = 'You updated your account successfully'
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
    params.require(:user).permit(:name, :email, :location, :sex, :dob, :bio, :language, :skillset, :password, :password_confirmation, :avatar, :short_description, :tw_url, :fb_url, :ta_url)
  end

  # devise override requireing password for update
  def needs_password?(user, params)
    user.email != params[:user][:email] || params[:user][:password].present?
  end
end