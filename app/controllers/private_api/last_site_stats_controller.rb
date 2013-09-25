class PrivateApi::LastSiteStatsController < SublimeVideoPrivateApiController

  # GET /private_api/sites/:site_token/last_site_stats
  def index
    stats = LastSiteStat.where(_args).asc(:time).limit(60)

    if stale?(etag: _args, last_modified: params[:since] || stats.max(:time))
      respond_with(stats: stats)
    end
  end

  private

  def _args
    params.slice(:site_token, :video_uid)
  end

end
