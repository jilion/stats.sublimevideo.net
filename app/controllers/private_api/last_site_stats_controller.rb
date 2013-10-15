class PrivateApi::LastSiteStatsController < SublimeVideoPrivateApiController
  include LastStatsableController

  # GET /private_api/last_site_stats
  def index
    @stats = LastSiteStat.where(_args).desc(:time).limit(60)
    if stale?(etag: _args, last_modified: _last_modified)
      respond_with(@stats)
    end
  end

end
