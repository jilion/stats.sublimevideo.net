require 'sidekiq'

require 'site_admin_stat'
require 'site_stat'
require 'video_stat'

class StatsMigratorWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'stats'

  attr_accessor :data

  def perform(stat_class, data)
    @data = data.symbolize_keys
    send("_migrate_#{stat_class.parameterize('_')}")
  end

  private

  def _migrate_stat_site_day
    updates = {
      :$inc => _app_loads_inc,
      :$set => { 'ss' => data[:ssl], 'sa' => data[:stages] } }
    SiteAdminStat.update_stats(_site_args, updates)
  end

  def _app_loads_inc
    loads = data[:app_loads].slice(*%w[m e s d i])
    loads = loads.map { |k, v| ["al.#{k}", v] }
    Hash[*loads.flatten]
  end

  def _migrate_stat_video_day
    SiteAdminStat.update_stats(_site_args, _admin_stat_updates)
    if _valid_video_uid?
      SiteStat.update_stats(_site_args, _stat_updates)
      VideoStat.update_stats(_video_args, _stat_updates)
    end
  end

  def _admin_stat_updates
    { :$inc => [
      _video_loads_inc,
      _video_views_inc
    ].inject(:merge) }
  end

  def _stat_updates
    { :$inc => [
      _video_loads_inc,
      _video_views_inc,
      _player_mode_and_device_inc,
      _browser_and_platform_inc
    ].inject(:merge) }
  end

  def _video_loads_inc
    { 'lo.w' => data[:video_loads]['m'] + data[:video_loads]['e'],
      'lo.e' => data[:video_loads]['em'] }
  end

  def _video_views_inc
    { 'st.w' => data[:video_views]['m'] + data[:video_views]['e'],
      'st.e' => data[:video_views]['em'] }
  end

  def _player_mode_and_device_inc
    html  = data[:player_mode_and_device]['h'] || {}
    flash = data[:player_mode_and_device]['f'] || {}
    { 'de.w.d' => html['d'].to_i + flash['d'].to_i,
      'de.w.m' => html['m'].to_i + flash['m'].to_i }
  end

  def _browser_and_platform_inc
    bp = data[:browser_and_platform].map { |k, v| ["bp.w.#{k}", v] }
    Hash[*bp.flatten]
  end

  def _site_args
    data.slice(:site_token, :time)
  end

  def _video_args
    data.slice(:site_token, :video_uid, :time)
  end

  def _valid_video_uid?
    data[:video_uid] =~ /^[a-z0-9_\-]{1,64}$/i
  end
end
