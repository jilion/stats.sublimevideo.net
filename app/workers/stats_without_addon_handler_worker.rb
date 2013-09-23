require 'stats_handler_base_worker'

class StatsWithoutAddonHandlerWorker < StatsHandlerBaseWorker
  sidekiq_options queue: 'stats-slow'

  private

  def _handle_l_event
    SiteAdminStatUpserter.upsert(_site_args, :loads, data)
  end

  def _handle_s_event
    SiteAdminStatUpserter.upsert(_site_args, :starts, data)
  end

end
