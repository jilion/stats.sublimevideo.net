require 'sidekiq'
# require 'kiqstand'

# Sidekiq.configure_server do |config|
#   # http://mongoid.org/en/mongoid/docs/tips.html#sidekiq
#   config.server_middleware do |chain|
#     chain.add Kiqstand::Middleware
#   end
# end

Sidekiq.configure_client do |config|
  config.redis = { size: 2 } # for web dyno
end
