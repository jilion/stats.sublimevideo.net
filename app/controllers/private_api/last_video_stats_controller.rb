class PrivateApi::LastVideoStatsController < SublimeVideoPrivateApiController
  include LastStatsableController

  # GET /private_api/sites/:site_token/videos/:video_uid/last_video_stats
  def index
    @stats = LastVideoStat.where(_args).asc(:time).limit(60)

    if stale?(etag: _args, last_modified: _last_modified)
      respond_with(stats: @stats)
    end
  end

end
