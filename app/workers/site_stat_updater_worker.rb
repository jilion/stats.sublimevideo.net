require 'sidekiq'

require 'site_stat'
require 'data_analyzer'

class SiteStatUpdaterWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'stats'

  def perform(site_args, event_field, data)
    data = DataAnalyzer.new(data)
    SiteStat.inc_stats(site_args, event_field, data)
  end
end
