Rails.application.routes.draw do
  resources :users, only: [:index, :show]
  root 'projects#index'
  resources :projects
end
