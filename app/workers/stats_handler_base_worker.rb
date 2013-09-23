require 'sidekiq'

require 'data_hash'
require 'librato_stats_incrementer'
require 'site_admin_stat_upserter'

class StatsHandlerBaseWorker
  include Sidekiq::Worker

  attr_accessor :data

  def perform(event_key, data)
    @data = DataHash.new(data)
    send("_handle_#{event_key}_event")
    LibratoStatsIncrementer.increment(event_key, @data)
  end

  private

  def _handle_al_event
    SiteAdminStatUpserter.upsert(_site_args, :app_loads, data)
  end

  def _site_args
    @site_args ||= data.slice('s', 't')
  end

  def _video_args
    @video_args ||= data.slice('s', 'u', 't')
  end

  def _valid_video_uid?
    data.key?('u')
  end
end
