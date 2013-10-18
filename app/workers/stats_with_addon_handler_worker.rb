require 'stats_handler_base_worker'

require 'last_play_creator'
require 'last_site_stat'
require 'last_video_stat'
require 'site_stat'
require 'video_stat'

class StatsWithAddonHandlerWorker < StatsHandlerBaseWorker
  sidekiq_options queue: 'stats'

  private

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

end
