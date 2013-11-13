web:    env MONGOID_POOL_SIZE=1 bundle exec unicorn -p $PORT -c ./config/unicorn.rb
worker: env LIBRATO_AUTORUN=1 bundle exec sidekiq -c ${SIDEKIQ_CONCURRENCY:-10} -q stats,2 -q stats-slow,1
