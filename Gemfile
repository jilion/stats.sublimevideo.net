source 'https://rubygems.org'
source 'https://8dezqz7z7HWea9vtaFwg@gem.fury.io/me/' # thibaud@jilion.com account

ruby '2.0.0'

gem 'rails', '4.0.0.rc1'

gem 'sublime_video_private_api', '~> 1.0' # hosted on gemfury
gem 'configurator', github: 'jilion/configurator'

gem 'mongoid', github: 'mongoid/mongoid'

gem 'kiqstand', github: 'mongoid/kiqstand'
gem 'sidekiq'

gem 'airbrake'
gem 'librato-rails', github: 'librato/librato-rails', branch: 'feature/rack_first'
gem 'librato-sidekiq'

gem 'rack-status'
gem 'has_scope'
gem 'newrelic_rpm'

gem 'geoip'
gem 'useragent', github: 'jilion/useragent' # needed for stat_request_parser

group :staging, :production do
  gem 'thin'
  gem 'lograge'
  gem 'dalli'
  gem 'rack-cache'
end

group :development, :test do
  gem 'rspec-rails'
end

group :development do
  # Guard
  gem 'ruby_gntp'

  gem 'guard-pow'
  gem 'guard-rspec'
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
