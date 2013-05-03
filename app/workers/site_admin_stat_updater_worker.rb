require 'sidekiq'

require 'site_admin_stat'

class SiteAdminStatUpdaterWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'stats'

  def perform(site_args, event_field, data)
    # SiteAdminStat.update_stats(site_args, ...)
  end
end
