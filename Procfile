web:    bundle exec unicorn -p $PORT -c ./config/unicorn.rb
worker: env LIBRATO_AUTORUN=1 bundle exec sidekiq -c 20 -q stats,2 -q stats-slow,1
worker_migration: env LIBRATO_AUTORUN=1 bundle exec sidekiq -c 10 -q stats-migration
scheduler: bundle exec rake scheduler:scale_dynos
