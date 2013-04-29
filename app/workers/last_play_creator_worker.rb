require 'sidekiq'

require 'last_play'
require 'geoip_wrapper'
require 'user_agent_wrapper'

class LastPlayCreatorWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'stats'

  attr_accessor :data

  def perform(data)
    @data = data
    LastPlay.create(params)
  end

  private

  def params
    hash = data.slice(*%w[s u t du ru ex])
    hash['co'] = country_code_from_ip
    hash['br'], hash['pl'] = browser_code_and_platform_code_from_user_agent
    hash
  end

  def country_code_from_ip
    GeoIPWrapper.country(data['ip'])
  end

  def browser_code_and_platform_code_from_user_agent
    user_agent = UserAgentWrapper.new(data['ua'])
    [user_agent.browser_code, user_agent.platform_code]
  end

end
