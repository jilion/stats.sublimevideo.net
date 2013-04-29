require 'sidekiq'

require 'last_site_stat'

class LastSiteStatUpdaterWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'stats'

  def perform(site_args, field)
    LastSiteStat.inc_stat(site_args, field)
  end
end
