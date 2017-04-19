if ENV['AIRBRAKE_PROJECT_ID'].present? && ENV['AIRBRAKE_API_KEY'].present?

  require 'airbrake/sidekiq/error_handler'

  Airbrake.configure do |c|
    c.project_id = ENV['AIRBRAKE_PROJECT_ID']
    c.project_key = ENV['AIRBRAKE_API_KEY']
    c.root_directory = Rails.root
    c.logger = Rails.logger
    c.environment = ENV['APP_NAME'] || Rails.env
    c.ignore_environments = %w[development test]

    # A list of parameters that should be filtered out of what is sent to
    # Airbrake. By default, all "password" attributes will have their contents
    # replaced.
    # https://github.com/airbrake/airbrake-ruby#blacklist_keys
    # Alternatively, you can integrate with Rails' filter_parameters.
    # Read more: https://goo.gl/gqQ1xS
    # c.blacklist_keys = Rails.application.config.filter_parameters
    c.blacklist_keys = [
      /password/i,
      /authorization/i,
      /api_?key/i,
    ]
  end

end
