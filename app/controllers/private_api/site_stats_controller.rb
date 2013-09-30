class PrivateApi::SiteStatsController < SublimeVideoPrivateApiController

  # GET /private_api/sites/:site_token/site_stats
  def index
    stats = SiteStat.last_hours_stats(_args, params[:hours])

    if stale?(etag: params, last_modified: stats.max(:time))
      respond_with(stats: stats)
    end
  end

  # GET /private_api/sites/:site_token/site_stats/last_days_starts
  def last_days_starts
    starts = SiteStat.last_days_starts(_args, params[:days])

    respond_with(starts: starts)
  end

  private

  def _args
    params.slice(:site_token)
  end

end
