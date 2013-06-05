class PrivateApi::SiteStatsController < SublimeVideoPrivateApiController

  # GET /private_api/sites_stats/:id/last_days_starts
  def last_days_starts
    starts = SiteStat.last_days_starts({ site_token: params[:id] }, params[:days].to_i)
    respond_with(starts: starts)
  end
end
