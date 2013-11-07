require 'librato-rails'

class LibratoStatsIncrementer
  attr_accessor :event_key, :data

  def initialize(event_key, data)
    @event_key = event_key
    @data = data
  end

  def self.increment(event_key, data)
    new(event_key, data).increment
  end

  def increment
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
      'data.app_load.stats_addon' => data.stats_addon? ? 'on' : 'off',
      'data.app_load.stage' => data.stage,
      'data.app_load.flash_version' => data.fv || 'none',
      'data.app_load.jquery_version' => data.jq || 'none' })
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
