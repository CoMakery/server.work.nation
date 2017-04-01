Rails.application.routes.draw do
  root 'authentications#new'
  
  get 'projects/index'

  resources :authentications, only: [:new, :create]
  get '/login', to: 'authentications#new', as: 'login'
end
