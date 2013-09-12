require 'sidekiq'

require 'librato_stats_incrementer_worker'
require 'last_play_creator_worker'
require 'last_site_stat_updater_worker'
require 'last_video_stat_updater_worker'
require 'site_admin_stat_updater_worker'
require 'site_stat_updater_worker'
require 'video_stat_updater_worker'

class StatsHandlerWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'stats'

  attr_accessor :data

  def perform(event_key, data)
    @data = data
    send("_handle_#{event_key}_event")
    LibratoStatsIncrementerWorker.perform_async(event_key, data)
  end

  private

  def _handle_al_event
    SiteAdminStatUpdaterWorker.perform_async(_site_args, :app_loads, data)
  end

  def _handle_l_event
    if _valid_video_uid?
      LastSiteStatUpdaterWorker.perform_async(_site_args, :loads)
      LastVideoStatUpdaterWorker.perform_async(_video_args, :loads)
      SiteStatUpdaterWorker.perform_async(_site_args, :loads, data)
      VideoStatUpdaterWorker.perform_async(_video_args, :loads, data)
    end
    SiteAdminStatUpdaterWorker.perform_async(_site_args, :loads, data)
  end

  def _handle_s_event
    if _valid_video_uid?
      LastPlayCreatorWorker.perform_async(data)
      LastSiteStatUpdaterWorker.perform_async(_site_args, :starts)
      LastVideoStatUpdaterWorker.perform_async(_video_args, :starts)
      SiteStatUpdaterWorker.perform_async(_site_args, :starts, data)
      VideoStatUpdaterWorker.perform_async(_video_args, :starts, data)
    end
    SiteAdminStatUpdaterWorker.perform_async(_site_args, :starts, data)
  end

  def _site_args
    @site_args ||= { site_token: data.delete('s'), time: data.delete('t') }
  end

  def _video_args
    @video_args ||= _site_args.merge(video_uid: data.delete('u'))
  end

  def _valid_video_uid?
    data.key?('u')
  end
end
