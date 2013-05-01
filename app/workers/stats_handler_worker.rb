require 'sidekiq'

require 'last_play_creator_worker'
require 'last_site_stat_updater_worker'
require 'last_video_stat_updater_worker'
require 'site_stat_updater_worker'
require 'video_stat_updater_worker'

class StatsHandlerWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'stats'

  attr_accessor :data

  def perform(event_key, data)
    @data = data
    send("handle_#{event_key}_event")
  end

  private

  def handle_l_event
    LastSiteStatUpdaterWorker.perform_async(site_args, :loads)
    LastVideoStatUpdaterWorker.perform_async(video_args, :loads)

    SiteStatUpdaterWorker.perform_async(site_args, data)
    VideoStatUpdaterWorker.perform_async(video_args, data)
  end

  def handle_s_event
    LastPlayCreatorWorker.perform_async(data)

    LastSiteStatUpdaterWorker.perform_async(site_args, :starts)
    LastVideoStatUpdaterWorker.perform_async(video_args, :starts)

    SiteStatUpdaterWorker.perform_async(site_args, data)
    VideoStatUpdaterWorker.perform_async(video_args, data)
  end

  def site_args
    @site_args ||= { site_token: data.delete('s'), time: data.delete('t') }
  end

  def video_args
    @video_args ||= site_args.merge(video_uid: data.delete('u'))
  end
end
