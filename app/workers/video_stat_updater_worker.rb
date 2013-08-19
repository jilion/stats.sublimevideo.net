require 'sidekiq'

require 'video_stat'
require 'data_hash'

class VideoStatUpdaterWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'stats'

  def perform(video_args, event_field, data)
    data = DataHash.new(data)
    VideoStat.inc_stats(video_args.symbolize_keys, event_field.to_sym, data)
  end
end
