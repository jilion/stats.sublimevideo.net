class PrivateApi::LastSiteStatsController < SublimeVideoPrivateApiController
  include LastStatsableController

  # GET /private_api/sites/:site_token/last_site_stats
  def index
    @stats = LastSiteStat.where(_args).asc(:time).limit(60)

    if stale?(etag: _args, last_modified: _last_modified)
      respond_with(stats: @stats)
    end
  end

end
