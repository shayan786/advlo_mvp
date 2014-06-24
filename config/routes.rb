Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  devise_for :users, :controllers => {:omniauth_callbacks => "omniauth_callbacks", :registrations => "registrations"}
  ActiveAdmin.routes(self)
  
  root to: 'application#homepage'
  
  #profile show route
  get 'users/:id'						=> 'users#show'

  #adventure controller routes
  get '/adventures/info'              => 'adventures#hosting_info'
  get '/adventures/request'           => 'adventures#request_info'
  get '/adventures/create'            => 'adventures#create'
  get '/adventures/create_prefill'		=> 'adventures#create_prefill'
  resources :adventures
 

end	
