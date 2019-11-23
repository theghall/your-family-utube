source 'https://rubygems.org'

ruby '2.5.1'

# Framwork
gem 'rails', '5.2.3'
# Presentation
gem 'sass-rails', '5.0.7'
gem 'bootstrap-sass', '3.4.1'
gem 'will_paginate', '3.1.5'
gem 'bootstrap-will_paginate', '1.0.0'
# Assest utilities
gem 'uglifier', '3.2.0'
gem 'coffee-rails', '4.2.2'
# Libraries
# Devise: user authtentication
gem 'devise', '4.7.1'
gem 'jquery-rails', '4.3.3'
gem 'jquery-ui-rails', '6.0.1'
gem 'jquery-serialize-object-rails', '2.5.0.1'
# Yt: Youtube API
gem 'yt', '0.32.0'
gem 'turbolinks', '5.0.1'
# For downloading video thumbnail
gem 'fog', '1.42.0', require: 'fog/aws'
gem 'carrierwave', '1.1.0'

# Use Puma as the app server
gem 'puma', '3.9.1'

# Utilities
gem 'faker',  '1.7.3'
gem 'rollbar', '2.15.4'
gem 'seedbank', '0.4.0'

# Database
gem 'pg', '0.18.4'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '3.7.0'
  gem 'listen', '3.1.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring', '2.0.2'
  gem 'spring-watcher-listen', '2.0.1'
end

group :test do
  gem 'rails-controller-testing', '1.0.2'
  gem 'minitest-reporters', '1.1.14'
  gem 'guard', '2.13.0'
  gem 'guard-minitest', '2.4.4'
end

group :production do
  gem 'newrelic_rpm', '4.4.0.336'
end

