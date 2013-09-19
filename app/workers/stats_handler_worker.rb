require 'sidekiq'

require 'last_site_stat'
require 'last_video_stat'
require 'site_stat'
require 'video_stat'
require 'librato_stats_incrementer'
require 'last_play_creator'
require 'site_admin_stat_upserter'

class StatsHandlerWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'stats'

  attr_accessor :data

  def perform(event_key, data)
    @data = DataHash.new(data)
    send("_handle_#{event_key}_event")
    LibratoStatsIncrementer.increment(event_key, data)
  end

  private

  def _handle_al_event
    SiteAdminStatUpserter.upsert(_site_args, :app_loads, data)
  end

  def _handle_l_event
    if _valid_video_uid?
      LastSiteStat.upsert_stat(_site_args, :loads)
      LastVideoStat.upsert_stat(_video_args, :loads)
      SiteStat.upsert_stats_from_data(_site_args, :loads, data)
      VideoStat.upsert_stats_from_data(_video_args, :loads, data)
    end
      SiteAdminStatUpserter.upsert(_site_args, :loads, data)
  end

  def _handle_s_event
    if _valid_video_uid?
      LastPlayCreator.create(data)
      LastSiteStat.upsert_stat(_site_args, :starts)
      LastVideoStat.upsert_stat(_video_args, :starts)
      SiteStat.upsert_stats_from_data(_site_args, :starts, data)
      VideoStat.upsert_stats_from_data(_video_args, :starts, data)
    end
    SiteAdminStatUpserter.upsert(_site_args, :starts, data)
  end

  def _site_args
    @site_args ||= data.slice('s', 't')
  end

  def _video_args
    @video_args ||= data.slice('s', 'u', 't')
  end

  def _valid_video_uid?
    data.key?('u')
  end
end
