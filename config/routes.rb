Rails.application.routes.draw do
  resources :projects
  root 'projects#index'
  get 'projects/index'
end
