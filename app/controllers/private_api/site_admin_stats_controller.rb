class PrivateApi::SiteAdminStatsController < SublimeVideoPrivateApiController

  # GET /private_api/sites/:site_token/site_stats/last_days_starts
  def index
    stats = SiteAdminStat.where(_args).last_days(params[:days].to_i).asc(:time).all

    if stale?(etag: params, last_modified: stats.max(:time))
      respond_with(stats: stats)
    end
  end

  private

  def _args
    params.slice(:site_token)
  end

end
