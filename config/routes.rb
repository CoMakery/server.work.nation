require 'sidekiq/web'

Rails.application.routes.draw do
  root 'users#index'
  resources :users, only: %i[index show]
  resources :projects

  unless Rails.env.development? || Rails.env.test?
    Sidekiq::Web.use Rack::Auth::Basic do |username, password|
      username.present? && password.present? &&
        username == ENV['SIDEKIQ_USERNAME'] && password == ENV['SIDEKIQ_PASSWORD']
    end
  end
  mount Sidekiq::Web, at: '/admin/sidekiq'
end
