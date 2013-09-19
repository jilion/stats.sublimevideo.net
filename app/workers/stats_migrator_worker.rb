require 'sidekiq'

require 'site_admin_stat'
require 'site_stat'
require 'video_stat'

class StatsMigratorWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'stats-migration'

  attr_accessor :data

  def perform(stat_class, data)
    @data = data.symbolize_keys
    send("_migrate_#{stat_class.parameterize('_')}")
  end

  private

  def _migrate_stat_site_day
    updates = {
      :$inc => _app_loads_inc,
      :$set => {
        'ss' => data[:ssl] == 'true',
        'sa' => data[:stages] } }
    SiteAdminStat.upsert_stats(_site_args, updates)
  end

  def _app_loads_inc
    loads = data[:app_loads].slice(*%w[m e s d i])
    loads = loads.map { |k, v| ["al.#{k}", v.to_i] }
    Hash[*loads.flatten]
  end

  def _migrate_stat_video_day
    SiteAdminStat.upsert_stats(_site_args, _admin_stat_updates)
    SiteStat.upsert_stats(_site_args, _stat_updates)
    VideoStat.upsert_stats(_video_args, _stat_updates) if _valid_video_uid?
  end

  def _admin_stat_updates
    { :$inc => [
      _sum_inc(:loads, :lo),
      _sum_inc(:starts, :st)
    ].inject(:merge) }
  end

  def _stat_updates
    { :$inc => [
      _sum_inc(:loads, :lo),
      _sum_inc(:starts, :st),
      _player_mode_and_device_inc,
      _browser_and_platform_inc
    ].inject(:merge) }
  end

  def _sum_inc(key, field)
    { "#{field}.w" => data[key]['m'].to_i + data[key]['e'].to_i,
      "#{field}.e" => data[key]['em'].to_i }
  end

  def _player_mode_and_device_inc
    html  = data[:player_mode_and_device]['h'] || {}
    flash = data[:player_mode_and_device]['f'] || {}
    { 'de.w.d' => html['d'].to_i + flash['d'].to_i,
      'de.w.m' => html['m'].to_i + flash['m'].to_i }
  end

  def _browser_and_platform_inc
    bp = data[:browser_and_platform].map { |k, v| ["bp.w.#{k}", v.to_i] }
    Hash[*bp.flatten]
  end

  def _site_args
    data.slice(:site_token).merge(time: _parsed_time)
  end

  def _video_args
    data.slice(:site_token, :video_uid).merge(time: _parsed_time)
  end

  def _parsed_time
    Time.parse(data[:time])
  end

  def _valid_video_uid?
    data[:video_uid] =~ /^[a-z0-9_\-]{1,64}$/i
  end
end
