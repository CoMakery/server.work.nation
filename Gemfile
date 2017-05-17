source 'https://rubygems.org'
ruby '2.3.1'

# gem 'airbrake'
gem 'acts-as-taggable-on', git: 'https://github.com/mbleigh/acts-as-taggable-on.git' # until this fix is released to rubygems: https://github.com/mbleigh/acts-as-taggable-on/issues/808
gem 'awesome_print'
gem 'base58', git: 'https://github.com/CoMakery/base58.git', ref: '546c86193002d1e0beed8335044649845f6650dc'
gem 'colorize'
gem 'easy_shell'
gem 'ethereum.rb', git: 'https://github.com/CoMakery/ethereum.rb.git', ref: 'dev'
# gem 'ethereum.rb', path: '~/code/ethereum.rb'
gem 'factory_girl_rails'  # used on staging for seed data
gem 'faker'               # used on staging for seed data
gem 'httparty'
gem 'nilify_blanks'
# gem 'olive_branch'
gem 'pattern_expander', git: 'https://github.com/harlantwood/pattern_expander.git', ref: 'hex' # used on staging for seed data
# gem 'pattern_expander', path: '~/code/pattern_expander'    # used on staging for seed data
gem 'pg'
gem 'puma'
gem 'rack-cors' # Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem 'rails', '5.1.0'
gem 'sentry-raven'
gem 'sidekiq'
gem 'sidekiq-failures'
gem 'sidekiq-scheduler'

group :development, :test do
  gem 'dotenv-rails'
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'rspec-rails'
end

group :development do
  gem 'brakeman', require: false
  gem 'foreman'
  gem 'listen'
  gem 'pivotal_git_scripts'
  gem 'rails_best_practices'
  gem 'rerun'
  gem 'rubocop', require: false
  gem 'rubocop-rspec'
  gem 'spring'
  gem 'spring-watcher-listen'
end

group :production do
  gem 'rails_12factor'
end
