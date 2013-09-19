require 'sidekiq'
require 'librato-rails'

require 'data_hash'

class LibratoStatsIncrementerWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'stats-low'

  attr_accessor :data, :event_key

  def perform(event_key, data)
    @data = DataHash.new(data)
    increments = send("_increments_for_#{event_key}")
    increments.each do |key, source|
      Librato.increment key, source: source
    end
  end

  private

  def _increments_for_al
    _base_increments('app_load').merge({
      'data.app_load.hostname' => data.hostname,
      'data.app_load.ssl' => data.ss ? 'on' : 'off',
      'data.app_load.stage' => data.stage,
      'data.app_load.flash_version' => data.fv || 'none',
      'data.app_load.jquery_version' => data.jq || 'none',
      'data.app_load.screen_resolution' => data.sr,
      'data.app_load.screen_dpr' => data.sd,
      'data.app_load.browser_language' => data.bl || 'undefined' })
  end

  def _increments_for_l
    _increments_for_load_and_start('load')
  end

  def _increments_for_s
    _increments_for_load_and_start('start')
  end

  def _increments_for_load_and_start(event)
    _base_increments(event).merge({
      "data.#{event}.device" => data.device,
      "data.#{event}.tech" => data.tech,
      "data.#{event}.source" => data.source,
      "data.#{event}.embedded" => data.em ? 'true' : 'false' })
  end

  def _base_increments(event)
    { "data.#{event}.country" => data.country_code,
      "data.#{event}.browser" => data.browser_code,
      "data.#{event}.platform" => data.platform_code, }
  end
end
