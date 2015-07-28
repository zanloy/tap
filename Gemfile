source 'https://rubygems.org'

ruby '2.1.4'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.1'
# Use PostgreSQL as the database for Active Record
gem 'pg'
# Use i18n-tasks gem for i18n testing
gem 'i18n-tasks'
# Use SCSS for stylesheets
gem 'sass-rails'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier'
# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'therubyracer', platforms: :ruby
# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', group: :doc
# Use ActiveModel has_secure_password
gem 'bcrypt'
# Use Google OAuth for authentication
gem 'omniauth-google-oauth2'
# Load environment variables from .env files
gem 'dotenv-rails'
# Use foreman for process handling
gem 'foreman'
# Use Puma concurrent web server
gem 'puma'
# Use Slim templates instead of ERB
gem 'slim-rails'
# Use bootstrap css (http://getbootstrap.com)
gem 'bootstrap-sass', '~> 3.3.4'
# Awesome font?
gem 'font-awesome-sass'
# Easy sign-in with social icons and buttons
gem 'bootstrap-social-rails'
# Use will_paginate for pagination helpers
gem 'will_paginate', '~> 3.0.5'
# Allow us to set delayed_jobs
gem 'delayed_job_active_record'
# Use CanCanCan for role based access
gem 'cancancan'
# Generates simple forms (bootstrap compatible)
gem 'simple_form'
# Use Cocoon for some jquery form type shit
gem 'cocoon'
# Use jquery-ui for pretty ui shit
gem 'jquery-ui-rails'
# Pretty alert windows
gem 'sweetalert-rails'
# Override default alerts with sweetalert
gem 'sweet-alert-confirm'
# Adds autocomplete option to simple forms
gem 'rails-jquery-autocomplete'
# Use state_machine for state
gem 'state_machine'

group :production do
  gem 'mailgun_rails'
end

group :development do
  gem 'awesome_print'
  # Deploy with capistrano!
  gem 'capistrano-rails'
  gem 'capistrano-rbenv'
  #gem 'capistrano-file-permissions'
  # Use coveralls for code coverage testing
  gem 'coveralls', require: false
  # Use guard for continous testing
  gem 'guard-rspec'
  gem 'pry-rails'
  gem 'rb-readline'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end

group :development, :test do
  # Test with capybara
  gem 'capybara'
  # Used to truncate databases between tests
  gem 'database_cleaner'
  # Use factory_girl to create mock models for testing
  gem 'factory_girl_rails'
  # Use ffaker gem to generate fake data for testing
  gem 'ffaker'
  # Allow you to use save_and_open_page in rspec tests
  gem 'launchy'
  # Display notifications in linux
  gem 'libnotify', require: false
  # Allow you to create mock items in testing
  gem 'rspec-activemodel-mocks'
  # Use RSpec instead of testunit
  gem 'rspec-rails'
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console'
  # Display notifications in mac os x
  #gem 'ruby_gntp', require: false
end
