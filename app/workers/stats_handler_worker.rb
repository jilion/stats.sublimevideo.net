require 'sidekiq'

require 'last_site_stat_updater_worker'
require 'last_video_stat_updater_worker'

class StatsHandlerWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'stats'

  attr_accessor :site_token, :video_uid, :time, :data


  def perform(event_key, data)
    @site_token = data.delete('s')
    @video_uid  = data.delete('u')
    @time       = data.delete('t')
    @data       = data

    send("handle_#{event_key}_event")
  end

  private

  def handle_l_event
    LastSiteStatUpdaterWorker.perform_async(site_args, :loads)
    LastVideoStatUpdaterWorker.perform_async(video_args, :loads)
  end

  def handle_s_event
    LastSiteStatUpdaterWorker.perform_async(site_args, :starts)
    LastVideoStatUpdaterWorker.perform_async(video_args, :starts)
  end

  def site_args
    { site_token: site_token, time: time }
  end

  def video_args
    site_args.merge(video_uid: video_uid)
  end
end
