class PlayWatcher
  attr_accessor :site_token, :video_uid

  def initialize(site_token, video_uid = nil)
    @site_token = site_token
    @video_uid = video_uid
  end

  def on_play
    Sidekiq.redis do |con|
      con.psubscribe(_channel) do |on|
        on.pmessage { |pattern, channel, message| yield(message) } # time
      end
    end
  end

  private

  def _channel
    "#{site_token}:#{video_uid || '*'}"
  end
end
