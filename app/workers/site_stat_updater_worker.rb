require 'sidekiq'

require 'site_stat'

class SiteStatUpdaterWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'stats'

  def perform(site_args, data)
    SiteStat.inc_stats(site_args, data)
  end
end
