source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 4.2.3'

# 環境変数設定
gem 'dotenv-rails', require: 'dotenv/rails-now'

# Use sqlite3 as the database for Active Record
# gem 'sqlite3'
# Use Firebird as the database for Active Record
gem 'activerecord-fb-adapter'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
gem 'jquery-turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4', group: :doc

# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1'

# Use Unicorn as the app server on the staging and production environment
group :staging, :production do
  gem 'unicorn'
end

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# For styling
gem 'bootstrap-sass'
gem 'font-awesome-rails'
gem 'enum_help'

# For seed data
gem 'seed-fu', '~> 2.3'

# 管理機能
gem 'for_admin', path: 'for_admin'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'

  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'

  gem 'pry-rails'

  gem 'rails-erd'
end

group :test do
  gem 'minitest-reporters'
  gem 'mini_backtrace'
  gem 'guard'
  gem 'guard-minitest'
  gem 'factory_girl_rails', '~> 4.5'
end

group :input_server do
  gem 'xbee-ruby'
  gem 'serverengine'
end
