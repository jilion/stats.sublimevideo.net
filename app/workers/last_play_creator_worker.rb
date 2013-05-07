require 'sidekiq'

require 'last_play'
require 'data_hash'

class LastPlayCreatorWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'stats'

  attr_accessor :data

  def perform(data)
    @data = DataHash.new(data)
    LastPlay.create(_params)
  end

  private

  def _params
    hash = data.slice(*%w[s u t du ru ex])
    hash['co'] = data.country_code
    hash['br'] = data.browser_code
    hash['pl'] = data.platform_code
    hash
  end

end
