if ENV['SENTRY_DSN']
  Raven.configure do |config|
    config.sanitize_fields = Rails.application.config.filter_parameters.map(&:to_s)
    config.current_environment = ENV['APP_NAME'] || Rails.env.to_s
    # config options: https://docs.sentry.io/clients/ruby/config/
  end
end
