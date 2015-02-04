source 'https://rubygems.org'
ruby "2.1.5"

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.0'
# Use postgresql as the database for Active Record
#gem 'pg'
gem 'mysql2'
gem 'rb-readline'

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

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
gem 'unicorn'

# Use Capistrano for deployment
gem 'capistrano-rails', group: :development

gem 'rails_admin'

# https://codeclimate.com/
gem "codeclimate-test-reporter", group: :test, require: nil

# bootstrap
gem 'bootstrap-sass'
gem 'font-awesome-rails'

gem 'simple_form'

# auth
gem 'devise'
gem 'omniauth'
gem 'omniauth-twitter'

gem 'twitter'

gem 'setty'

gem 'shareable'

# markdown
gem "redcarpet"

# sidekiq
gem "sidekiq"
gem "sidekiq-cron", "~> 0.2.0"
gem 'sinatra', :require => nil

# heroku
gem 'puma'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'

  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'

  gem 'rspec'
  gem 'factory_girl'
  gem 'rspec-rails'
end

group :test do
  # heroku에서는 sqlite3를 못쓴다. 테스트용으로만 쓴다
  gem 'sqlite3'
end

group :production do
  # https://devcenter.heroku.com/articles/getting-started-with-rails4#heroku-gems
  gem 'rails_12factor'
end

# rails-assets
source 'https://rails-assets.org' do
  gem 'rails-assets-bootcards'
end
