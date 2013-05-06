require 'sidekiq'

require 'data_analyzer'
require 'site_admin_stat'

class SiteAdminStatUpdaterWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'stats'

  attr_accessor :data

  def perform(site_args, event_field, data)
    @data = DataAnalyzer.new(data)
    updates = send("_updates_for_#{event_field}")
    SiteAdminStat.update_stats(site_args, updates)
  end

  private

  def _updates_for_app_loads
    { :$inc => { "al.#{data.ho}" => 1 },
      :$set => { 'ss' => data.ss },
      :$addToSet => { 'sa' => data.st } }
  end

  def _updates_for_loads
    { :$inc => { "lo.#{data.source_provenance}" => 1 } }
  end

  def _updates_for_starts
    { :$inc => { "st.#{data.source_provenance}" => 1 } }
  end
end
