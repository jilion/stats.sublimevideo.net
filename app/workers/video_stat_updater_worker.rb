require 'sidekiq'

require 'video_stat'

class VideoStatUpdaterWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'stats'

  def perform(video_args, event_field, data)
    VideoStat.inc_stats(video_args, event_field, data)
  end
end
