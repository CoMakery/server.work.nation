require 'sidekiq/web'

Rails.application.routes.draw do
  root 'users#index'
  resources :projects, only: %i[index]
  resources :users, only: %i[index show], param: :uport_address
  resources :skills, only: %i[index]

  unless Rails.env.development? || Rails.env.test?
    Sidekiq::Web.use Rack::Auth::Basic, 'Sidekiq' do |_username, password|
      raise 'Password must be at least 8 characters long' unless ENV['SIDEKIQ_PASSWORD'].to_s.length >= 8
      Rack::Utils.secure_compare(ENV['SIDEKIQ_PASSWORD'], password)
    end
  end
  mount Sidekiq::Web, at: '/admin/sidekiq'
end
