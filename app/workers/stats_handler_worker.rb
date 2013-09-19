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
    LibratoStatsIncrementerWorker.new.perform(event_key, data)
  end

  private

  def _handle_al_event
    SiteAdminStatUpdaterWorker.new.perform(_site_args, :app_loads, data)
  end

  def _handle_l_event
    if _valid_video_uid?
      LastSiteStatUpdaterWorker.new.perform(_site_args, :loads)
      LastVideoStatUpdaterWorker.new.perform(_video_args, :loads)
      SiteStatUpdaterWorker.new.perform(_site_args, :loads, data)
      VideoStatUpdaterWorker.new.perform(_video_args, :loads, data)
    end
    SiteAdminStatUpdaterWorker.new.perform(_site_args, :loads, data)
  end

  def _handle_s_event
    if _valid_video_uid?
      LastPlayCreatorWorker.new.perform(data)
      LastSiteStatUpdaterWorker.new.perform(_site_args, :starts)
      LastVideoStatUpdaterWorker.new.perform(_video_args, :starts)
      SiteStatUpdaterWorker.new.perform(_site_args, :starts, data)
      VideoStatUpdaterWorker.new.perform(_video_args, :starts, data)
    end
    SiteAdminStatUpdaterWorker.new.perform(_site_args, :starts, data)
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
