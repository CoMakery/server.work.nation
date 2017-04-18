require 'sidekiq/web'

Rails.application.routes.draw do
  root 'users#index'
  resources :users, only: %i[index show]
  resources :projects

  unless Rails.env.development? || Rails.env.test?
    Sidekiq::Web.use Rack::Auth::Basic, 'Sidekiq' do |_username, password|
      raise unless ENV['SIDEKIQ_PASSWORD'].length >= 8
      Rack::Utils.secure_compare(ENV['SIDEKIQ_PASSWORD'], password)
    end
  end
  mount Sidekiq::Web, at: '/admin/sidekiq'
end
