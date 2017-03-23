source 'https://rubygems.org'
ruby '2.4.0'

# git_source(:github) do |repo_name|
#   repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
#   "https://github.com/#{repo_name}.git"
# end

# gem 'airbrake'
gem 'awesome_print'
gem 'coffee-rails'
gem 'jquery-rails'
gem 'momentjs-rails'
gem 'pg'
gem 'puma'
gem 'rails', '5.1.0.rc1'
# gem 'rails', git: 'git@github.com:rails/rails.git', ref: '5-1-stable'
gem 'sass-rails', github: "rails/sass-rails"
gem 'sqlite3'
gem 'turbolinks'
gem 'uglifier'
gem 'webpacker'

group :production do
  gem 'rails_12factor'
end

group :development, :test do
  gem 'dotenv-rails'
  gem 'pry-byebug'
  gem 'pry-rails'
end

group :development do
  gem 'rails_best_practices'
  gem 'brakeman', require: false
  gem 'listen'
  gem 'pivotal_git_scripts'
  gem 'rubocop', require: false
  gem 'spring'
  gem 'spring-watcher-listen'
  gem 'web-console'  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
end
