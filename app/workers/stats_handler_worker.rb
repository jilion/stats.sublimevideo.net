require 'sidekiq'

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
    LastSiteStatUpdaterWorker.perform_async(site_token, time, :loads)
    LastVideoStatUpdaterWorker.perform_async(site_token, video_uid, time, :loads)
  end

  def handle_s_event
    LastSiteStatUpdaterWorker.perform_async(site_token, time, :starts)
    LastVideoStatUpdaterWorker.perform_async(site_token, video_uid, time, :starts)
  end
end
