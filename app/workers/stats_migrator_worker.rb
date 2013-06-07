require 'sidekiq'

require 'site_admin_stat'

class StatsMigratorWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'stats'

  attr_accessor :data

  def perform(stat_class, data)
    @data = data.symbolize_keys
    send("_migrate_#{stat_class.parameterize('_')}")
  end

  private

  def _migrate_stat_site_day
    site_args = data.slice(:site_token, :time)
    updates = {
      :$inc => _app_loads_inc,
      :$set => { 'ss' => data[:ssl], 'sa' => data[:stages] } }
    SiteAdminStat.update_stats(site_args, updates)
  end

  def _app_loads_inc
    loads = data[:app_loads].slice(*%w[m e s d i])
    loads = loads.map { |k, v| ["al.#{k}", v] }
    Hash[*loads.flatten]
  end
end
