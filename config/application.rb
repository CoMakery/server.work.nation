require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
# require "sprockets/railtie"
require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module WorkNation
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true

    config.project_slug = 'worknation'

    # lib/ is for code that is entirely independent of your Rails app
    # app/lib/ is for code that expects Rails (esp. models) but which is not itself a model
    config.autoload_paths << Rails.root.join('app', 'lib')

    config.eager_load = false

    # if ENV['RAILS_LOG_TO_STDOUT'].present?
    #   logger           = ActiveSupport::Logger.new(STDOUT)
    #   logger.formatter = config.log_formatter
    #   config.logger    = ActiveSupport::TaggedLogging.new(logger)
    # end
    #
    # # Use a different logger for distributed setups.
    # # require 'syslog/logger'
    # # config.logger = ActiveSupport::TaggedLogging.new(Syslog::Logger.new 'app-name')
  end
end
