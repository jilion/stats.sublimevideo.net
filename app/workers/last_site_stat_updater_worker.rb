require 'sidekiq'

class LastVideoStatUpdaterWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'stats'

  def perform(site_token, video_uid, time, field)
  end
end
