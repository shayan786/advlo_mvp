Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  devise_for :users, :controllers => {:omniauth_callbacks => "omniauth_callbacks"}
  ActiveAdmin.routes(self)
  
  root 'application#homepage'
  
  #adventure controller routes
  get '/adventures/create_prefill'		=> 'adventures#create_prefill'
  post '/adventures/create_postfill'	=> 'adventures#create_postfill'
  resources :adventures
 

end	
