source 'https://rubygems.org'
source 'https://8dezqz7z7HWea9vtaFwg:@gem.fury.io/me/' # thibaud@jilion.com account

ruby '2.0.0'

gem 'rails', '4.0.5'

gem 'sublime_video_private_api', '~> 1.0' # hosted on gemfury

gem 'mongoid', github: 'mongoid'
gem 'moped', github: 'mongoid/moped'

gem 'sidekiq'

gem 'honeybadger'
gem 'librato-rails'
gem 'librato-sidekiq'

gem 'rack-status'
gem 'newrelic_rpm'

gem 'geoip'
gem 'useragent', github: 'jilion/useragent'
gem 'pusher'
gem 'faraday', '~> 0.8.9'

group :staging, :production do
  gem 'unicorn', require: false
  gem 'lograge'
  gem 'dalli'
  gem 'memcachier'
  gem 'rack-cache'
  gem 'rails_12factor'
end

group :development, :test do
  gem 'rspec-rails'
  gem 'dotenv-rails'
end

group :development do
  # Guard
  gem 'ruby_gntp', require: false
  gem 'guard-pow', require: false
  gem 'guard-rspec', require: false
end

group :test do
  gem 'timecop'
  gem 'shoulda-matchers'
  gem 'mongoid-rspec'
  gem 'vcr'
  gem 'webmock'
  gem 'factory_girl_rails'
  gem 'database_cleaner'
end
