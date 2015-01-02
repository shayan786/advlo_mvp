class OmniauthCallbacksController < Devise::OmniauthCallbacksController   
  def facebook     
     @user = User.find_for_facebook_oauth(request.env["omniauth.auth"], current_user) 

     @user.referrer_id = session[:referrer_id]
     @user.save

     if session[:user_credit]
       @user.credit = session[:user_credit]
       @user.save
       session[:user_credit] = 0.0
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
    if request.env['omniauth.params'] == {"affiliate" => "true"}
      @user.affiliate = true
      @user.save

      AdvloMailer.delay.new_affiliate_email(@user)

      '/affiliate#become_affiliate'
    elsif request.env['omniauth.params']['affiliate_referral'] == "true" && request.env['omniauth.params']['referrer_id'] && request.env['omniauth.params']['referrer_id'] != ''
      if @user.sign_in_count == 1
        if @affiliate_tracker = AffiliateTracker.find_by_referrer_id(request.env['omniauth.params']['referrer_id'])
          @affiliate_tracker.sign_ups = @affiliate_tracker.sign_ups + 1
          @affiliate_tracker.save
        else
          @affiliate_tracker = AffiliateTracker.create(referrer_id: request.env['omniauth.params']['referrer_id'])
          @affiliate_tracker.sign_ups = @affiliate_tracker.sign_ups + 1
          @affiliate_tracker.save
        end
      end

      '/users/edit'
    else
      
      '/users/edit'
    end
  end
end

