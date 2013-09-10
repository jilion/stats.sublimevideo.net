require 'sidekiq'

require 'last_play'
require 'data_hash'

class LastPlayCreatorWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'stats'

  attr_accessor :data

  def perform(data)
    @data = DataHash.new(data)
    params = _params
    LastPlay.create(params)
    _publish_on_redis(params)
  end

  private

  def _params
    hash = data.slice(*%w[s u t du ru ex])
    hash['co'] = data.country_code
    hash['br'] = data.browser_code
    hash['pl'] = data.platform_code
    hash
  end

  def _publish_on_redis(params)
    channel = "#{params['s']}:#{params['u']}"
    Sidekiq.redis { |con| con.publish(channel, params['t']) }
  end
end
