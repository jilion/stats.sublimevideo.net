require 'pusher'

class PusherWrapper

  def initialize(channel)
    @channel = channel
  end

  def trigger(event, data)
    if _channel_occupied?
      Pusher.trigger(@channel.to_s, event, data)
    end
  rescue Pusher::Error
    false
  end

  private

  def _channel_occupied?
    Sidekiq.redis { |con| con.sismember('pusher:channels', @channel) }
  end

end
