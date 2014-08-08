Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  devise_for :users, :controllers => {:omniauth_callbacks => "omniauth_callbacks", :registrations => "registrations"}
  ActiveAdmin.routes(self)
  
  #user dashboard route
  devise_scope :user do
    post '/users/contact_host'        => 'users#contact_host'
    get '/users/dashboard'            => 'registrations#dashboard'
    get '/users/wallet'               => 'registrations#wallet'
    get '/users/payouts'              => 'registrations#payouts'
    get '/users/reservations'         => 'registrations#reservations'
  end

  #contact
  post '/contact'                     => 'application#contact'

  #terms/conditions/privacy
  get '/terms'                        => 'application#terms'

  #profile show route
  resources :users, :only => [:show]

  #adventure controller routes
  get '/adventures/info'              => 'adventures#hosting_info'
  get '/adventures/request'           => 'adventures#request_info'
  get '/adventures/create'            => 'adventures#create'
  get '/adventures/create_prefill'		=> 'adventures#create_prefill'
  post '/adventures/requests'         => 'adventures#requests'
  post '/adventures/request_location' => 'adventures#request_location'

  get '/adventures/filter',           to: 'adventures#filter'

  resources :adventures
  resources :adventure_steps
  
  #events
  get '/events/reserved'              => 'events#reserved'
  resources :events
  
  #reservations
  post '/reservations/request'        => 'reservations#request_time'
  post '/reservations/host_cancel'    => 'reservations#host_cancel'
  post '/reservations/user_cancel'    => 'reservations#user_cancel'
  resources :reservations

  resources :reviews

  root to: 'application#homepage'
  
  resources :sitemaps, :only => :show
  get "sitemap" => "sitemaps#show"

  get '*not_found', to: 'application#render_error'
end	
