require 'sidekiq'

require 'site_admin_stat'

class SiteAdminPagesMigratorWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'stats-migration'

  attr_accessor :site_token

  def perform(site_token, pages)
    if site_admin_stat = SiteAdminStat.last_without_pages(site_token)
      site_admin_stat.update_attribute(:pages, pages)
    end
  end
end
