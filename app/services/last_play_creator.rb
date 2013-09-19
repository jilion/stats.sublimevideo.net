require 'last_play'
require 'pusher_wrapper'

class LastPlayCreator
  attr_accessor :data, :params

  def initialize(data)
    @data = data
    @params = _params
  end

  def self.create(data)
    new(data).create
  end

  def create
    LastPlay.create(params)
    _trigger_pusher
  end

  private

  def _params
    hash = data.slice(*%w[s u t du ru ex])
    hash['co'] = data.country_code
    hash['br'] = data.browser_code
    hash['pl'] = data.platform_code
    hash
  end

  def _trigger_pusher
    args = 'play', params['t'].to_i
    PusherWrapper.new("private-#{params['s']}").trigger(*args)
    PusherWrapper.new("private-#{params['s']}.#{params['u']}").trigger(*args)
  end
end
