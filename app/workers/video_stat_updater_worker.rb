require 'sidekiq'

require 'video_stat'

class VideoStatUpdaterWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'stats'

  def perform(video_args, data)
    VideoStat.inc_stats(video_args, data)
  end
end
