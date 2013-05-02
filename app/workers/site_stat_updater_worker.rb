require 'sidekiq'

require 'site_stat'

class SiteStatUpdaterWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'stats'

  def perform(site_args, event_field, data)
    SiteStat.inc_stats(site_args, event_field, data)
  end
end
