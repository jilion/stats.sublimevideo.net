require 'sidekiq'

require 'site_stat'
require 'data_hash'

class SiteStatUpdaterWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'stats'

  def perform(site_args, event_field, data)
    data = DataHash.new(data)
    SiteStat.inc_stats(site_args.symbolize_keys, event_field.to_sym, data)
  end
end
