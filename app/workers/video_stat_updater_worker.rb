require 'sidekiq'

require 'video_stat'
require 'data_analyzer'

class VideoStatUpdaterWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'stats'

  def perform(video_args, event_field, data)
    data = DataAnalyzer.new(data)
    VideoStat.inc_stats(video_args, event_field, data)
  end
end
