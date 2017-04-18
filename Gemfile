source 'https://rubygems.org'
ruby '2.3.1'

# git_source(:github) do |repo_name|
#   repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
#   "https://github.com/#{repo_name}.git"
# end

# gem 'airbrake'
gem 'awesome_print'
gem 'colorize'
gem 'easy_shell'
gem 'ethereum.rb', git: 'https://github.com/CoMakery/ethereum.rb.git', ref: 'dev'
# gem 'ethereum.rb', path: '~/code/ethereum.rb'
gem 'factory_girl_rails'  # used on staging for seed data
gem 'faker'               # used on staging for seed data
gem 'httparty'
gem 'pattern_expander'    # used on staging for seed data
gem 'pg'
gem 'puma'
gem 'rack-cors' # Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem 'rails', '5.1.0.rc1'
gem 'sidekiq'
gem 'sidekiq-failures'

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
