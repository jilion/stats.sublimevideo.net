require 'sidekiq'

class LastSiteStatUpdaterWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'stats'

  def perform(site_token, time, field)
  end
end
