Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  devise_for :users, :controllers => {:omniauth_callbacks => "omniauth_callbacks"}
  ActiveAdmin.routes(self)
  
  root 'application#homepage'
  
  resources :adventures
end	
