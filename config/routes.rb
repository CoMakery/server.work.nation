Rails.application.routes.draw do
  root 'users#index'
  resources :users, only: %i[index show]
  resources :projects
end
