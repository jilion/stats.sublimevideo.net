source 'https://rubygems.org'
source 'https://8dezqz7z7HWea9vtaFwg:@gem.fury.io/me/' # thibaud@jilion.com account

ruby '2.0.0'

gem 'rails', '4.0.0'

gem 'sublime_video_private_api', '~> 1.0' # hosted on gemfury

gem 'mongoid', github: 'mongoid/mongoid'

gem 'kiqstand', github: 'mongoid/kiqstand'
gem 'sidekiq'

gem 'honeybadger'
gem 'librato-rails'
gem 'librato-sidekiq'

gem 'rack-status'
gem 'has_scope'
gem 'newrelic_rpm'

gem 'geoip'
gem 'useragent', github: 'jilion/useragent' # needed for stat_request_parser
gem 'pusher'

group :staging, :production do
  gem 'puma', require: false
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
  gem 'webmock', '>= 1.8.0', '< 1.10'
  gem 'vcr'
  gem 'factory_girl_rails'
  gem 'database_cleaner'
end
