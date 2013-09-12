class PrivateApi::SiteStatsController < SublimeVideoPrivateApiController

  # GET /private_api/sites/:site_token/site_stats
  def index
    stats = SiteStat.last_hours_stats(_site_args, params[:hours].to_i)

    respond_with(stats: stats)
  end

  # GET /private_api/sites/:site_token/site_stats/last_days_starts
  def last_days_starts
    starts = SiteStat.last_days_starts(_site_args, params[:days].to_i)

    respond_with(starts: starts)
  end


  private

  def _site_args
    params.slice(:site_token)
  end

end
