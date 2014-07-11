Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  devise_for :users, :controllers => {:omniauth_callbacks => "omniauth_callbacks", :registrations => "registrations"}
  ActiveAdmin.routes(self)
  
  #user dashboard route
  devise_scope :user do
    get '/users/dashboard'            => 'registrations#dashboard'
    get '/users/wallet'               => 'registrations#wallet'
  end

  #profile show route
  resources :users, :only => [:show]

  #adventure controller routes
  get '/adventures/info'              => 'adventures#hosting_info'
  get '/adventures/request'           => 'adventures#request_info'
  get '/adventures/create'            => 'adventures#create'
  get '/adventures/create_prefill'		=> 'adventures#create_prefill'
  get '/adventures/reservations/:id'  => 'adventures#reservations'

  get '/adventures/:location/:category', to: 'adventures#filter_category'

  resources :adventures
  resources :adventure_steps
  resources :events
  resources :reservations
  resources :reviews

  root to: 'application#homepage'
  
  get '*not_found', to: 'application#render_error'
end	
