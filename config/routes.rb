Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  devise_for :users, :controllers => {:omniauth_callbacks => "omniauth_callbacks", :registrations => "registrations"}
  ActiveAdmin.routes(self)
  
  #user dashboard route
  devise_scope :user do
    post '/upload/hero_image'         => 'users#hero_image'
    post '/upload/user_avatar_image'  => 'users#update_profile_img'
    post '/upload/waiver'             => 'users#upload_waiver'
    post '/delete/waiver'             => 'users#delete_waiver'
    get '/users/dashboard'            => 'registrations#dashboard'
    get '/users/wallet'               => 'registrations#wallet'
    get '/users/payouts'              => 'registrations#payouts'
    get '/users/reservations'         => 'registrations#reservations'
    post '/users/phone'               => 'users#edit_phone_number'
    get '/users/conversations'        => 'registrations#conversations'
    post '/users/update_paypal_email' => 'users#update_paypal_email'
    post '/users/become_an_affiliate'  => 'users#become_an_affiliate'

    # Affiliate related tracking
    post '/users/update_affiliate_referral_click_count' => 'users#update_affiliate_referral_click_count'

    get '/users/initial/:type'        => 'registrations#inital_signin_check'
    get '/affiliate/:referral_code'   => 'registrations#referral_sign_up'

  end

  get 'invite/:invite'                => 'adventures#hosting_info'
  get 'partner'                       => 'adventures#hosting_info'


  # shy wants to hide you from the world
  # get 'travel-fund'                   => 'application#giveaway' 
  # get '/travel-fund/:referral_code'   => 'application#giveaway'

  # get 'giveaway/:promo_code'          => 'application#giveaway'
  # get 'giveaway'                      => 'application#giveaway'
  # post 'giveaway/:user_id'            => 'application#update_user_giveaway'
  get 'travel-fund'                   => 'application#homepage'
  get 'giveaway'                      => 'application#homepage'

  #contact
  post '/contact'                     => 'application#contact'

  #affiliate marketing
  get '/affiliate'                   => 'application#affiliate'

  #terms/conditions/privacy
  get '/terms'                        => 'application#terms'
  get '/about'                        => 'application#about'

  #investors
  get '/invest'                       => 'application#invest'

  #blog
  get '/blog'                         => 'blogpost#index'
  get '/blog/:permalink'              => 'blogpost#show'

  # email list 
  # post '/email-list'                  => 'emails#create'
  # get '/emails/unsubscribe/:id'       => 'emails#unsubscribe'
  # get '/email-list/unsubscriber/:id'  => 'emails#unsubscribe_email_list'

  #profile show route
  resources :users, :only => [:show]

  #adventure controller routes
  get '/adventures/info'              => 'adventures#hosting_info'
  get '/adventures/request'           => 'adventures#request_info'
  get '/adventures/create'            => 'adventures#create'
  get '/adventures/create_prefill'		=> 'adventures#create_prefill'
  post '/adventures/requests'         => 'adventures#requests'

  get '/adventures/filter',           to: 'adventures#filter'

  resources :adventures
  resources :adventure_steps
  
  #events
  resources :events
  
  #reservations
  post '/reservations/request'        => 'reservations#request_time'
  post '/reservations/host_cancel'    => 'reservations#host_cancel'
  post '/reservations/user_cancel'    => 'reservations#user_cancel'
  resources :reservations

  #reviews
  resources :reviews

  #conversations & messages
  post '/conversations/new'          => 'conversations#new'
  post '/messages/new'               => 'messages#new'
  post '/messages/read/:id'          => 'messages#read'            

  root to: 'application#homepage'

  resources :sitemap, only: [:index]

  #Stripe Webhooks
  post "/stripe-webhooks"             => 'stripe_hooks#receiver'

  #switch user from admin account
  get 'switch_user' => 'switch_user#set_current_user'

  #ajax for poll calculation
  get '/update-poll/:answer' => 'application#calculate_poll'

  # unsubscribe users mailer link
  get '/users/unsubscribe/:signature' => 'users#unsubscribe'
  get '/unsubscriber/:signature' => 'users#unsubscribe_email_list'


  get '*not_found', to: 'application#render_error'
end	
