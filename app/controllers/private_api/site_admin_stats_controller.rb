class PrivateApi::SiteAdminStatsController < SublimeVideoPrivateApiController

  # GET /private_api/site_admin_stats
  def index
    @stats = SiteAdminStat.where(_args).desc(:time)
    @stats = @stats.page(params[:page]).per(params[:per] || params[:days])
    @stats = @stats.last_days(params[:days].to_i) if params.key?(:days)
    if stale?(etag: params, last_modified: @stats.max(:time))
      respond_with(@stats)
    end
  end

  # GET /private_api/site_admin_stats/last_days_starts
  def last_days_starts
    starts = SiteAdminStat.last_days_starts(_args, params[:days])
    respond_with(starts)
  end

  # GET /private_api/site_admin_stats/last_pages
  def last_pages
    pages = SiteAdminStat.last_pages(params[:site_token], params.slice(:days, :limit))
    if stale?(etag: params)
      expires_in 1.hour, public: true
      respond_with(pages)
    end
  end

  # GET /private_api/site_admin_stats/global_day_stat?day=2013-10-04
  def global_day_stat
    day = Date.parse(params[:day])
    fields = [:app_loads, :loads, :starts]
    stat = SiteAdminStat.global_day_stat(day, [:app_loads, :loads, :starts])
    respond_with(stat.as_json(only: [:al, :lo, :st]))
  end

  # GET /private_api/site_admin_stats/last_30_days_sites_with_starts?day=2013-10-04&threshold=2
  def last_30_days_sites_with_starts
    count = SiteAdminStat.last_30_days_sites_with_starts(_day, threshold: params[:threshold])
    respond_with(count: count)
  end

  # GET /private_api/site_admin_stats/migration_totals
  def migration_totals
    totals = SiteAdminStat.migration_totals(params[:site_token], params[:day])
    respond_with(totals: totals)
  end

  private

  def _args
    params.slice(:site_token)
  end

  def _day
    Date.parse(params[:day])
  end

end
