source 'http://rubygems.org'

ruby '2.0.0', :engine => 'jruby',
              :engine_version => '1.7.19'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.0'
# Use jdbcsqlite3 as the database for Active Record
gem 'activerecord-jdbcsqlite3-adapter'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'therubyrhino'
# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Twitter Bootstrap
gem 'bootstrap-sass', '3.3.3'

# Adds pagination capabilities
gem 'will_paginate',           '3.0.7'
gem 'bootstrap-will_paginate', '0.0.10'

# Jobs
gem 'delayed_job_active_record'
gem 'daemons'

group :development, :test do
  gem 'jdbc-sqlite3', '3.8.7'
  gem 'binding_of_caller', '0.7.3.pre1'
  #gem 'byebug',      '3.4.0'
  gem 'web-console', '~> 2.0'
  gem 'cucumber-rails', :require => false
  gem 'test-factory', '~> 0.5.3'
  gem 'faker', '1.4.2'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
