require 'sidekiq'

require 'last_video_stat'

class LastVideoStatUpdaterWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'stats'

  def perform(video_args, field)
    LastVideoStat.inc_stat(video_args, field)
  end
end
