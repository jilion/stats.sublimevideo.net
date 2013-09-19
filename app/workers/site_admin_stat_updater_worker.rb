require 'sidekiq'

require 'data_hash'
require 'site_admin_stat'

class SiteAdminStatUpdaterWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'stats'

  attr_accessor :data

  def perform(site_args, event_field, data)
    @data = DataHash.new(data)
    updates = send("_updates_for_#{event_field}")
    SiteAdminStat.update_stats(site_args.symbolize_keys, updates)
  end

  private

  def _updates_for_app_loads
    { :$inc => { "al.#{data.ho}" => 1 },
      :$set => { 'ss' => data.ss },
      :$addToSet => { 'sa' => data.st } }
  end

  def _updates_for_loads
    { :$inc => { "lo.#{data.source_key}" => 1 } }
  end

  def _updates_for_starts
    { :$inc =>  { "st.#{data.source_key}" => 1 },
      :$push => { 'pa' => { :$each => [data.du].compact, :$slice => -10 } } }
  end
end
