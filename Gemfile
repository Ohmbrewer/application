source 'https://rubygems.org'

ruby '2.3.0'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.1'
# Use PostgreSQL as the database for Active Record
gem 'pg'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'therubyracer', platforms: :ruby
# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

gem 'yard', group: :doc

# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'

# Use attr_encrypted for things that need to be encrypted in the db, but can be displayed to the user
gem 'attr_encrypted'

# Use Puma as the app server
gem 'puma'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Twitter Bootstrap
gem 'bootstrap-sass', '3.3.3'

# Includes Google Charts via google_visualr
gem 'google_visualr', git: 'https://github.com/kyleoliveira/google_visualr.git' # , '~> 2.5', # '>= 2.5.1'

# Form fancification
gem 'cocoon', '1.2.6'

# Adds pagination capabilities
gem 'will_paginate',           '3.0.7'
gem 'bootstrap-will_paginate', '0.0.10'

# Jobs
gem 'delayed_job_active_record'
gem 'daemons'
gem 'particlerb'
gem 'aasm', '4.4.0'
gem 'closure_tree', '6.0.0'

group :development, :test do
  gem 'binding_of_caller', '0.7.3.pre1'
  gem 'byebug',      '3.4.0'
  gem 'cucumber-rails', require: false
  gem 'test-factory', '~> 0.5.3'
  gem 'faker', '1.4.2'
  gem 'rubocop', '~> 0.39.0', require: false
  gem 'simplecov', '0.12.0', require: false
  gem 'knapsack', '1.11.1'
end
gem 'web-console', '~> 2.0', group: :development
gem 'codeclimate-test-reporter', '0.6.0', group: :test, require: nil

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

# Include the rails_12factor gem for Heroku compatibility
gem 'rails_12factor', group: :production
