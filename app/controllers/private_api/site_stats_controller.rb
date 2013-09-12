class PrivateApi::SiteStatsController < SublimeVideoPrivateApiController

  # GET /private_api/sites/:site_token/site_stats/last_days_starts
  def last_days_starts
    starts = SiteStat.last_days_starts({ site_token: params[:site_token] }, params[:days].to_i)

    respond_with(starts: starts)
  end
end
