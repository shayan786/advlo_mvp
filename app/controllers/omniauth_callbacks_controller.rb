class OmniauthCallbacksController < Devise::OmniauthCallbacksController   
  def facebook     
     @user = User.find_for_facebook_oauth(request.env["omniauth.auth"], current_user) 

     @user.referrer_id = session[:referrer_id]
     @user.save

     if session[:user_credit]
       @user.credit = session[:user_credit]
       @user.save
     end
   
     if @user.persisted?       
      sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
      set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end

  def after_sign_in_path_for(resource)
    '/users/edit'
  end
end

