class PrivateApi::LastVideoStatsController < SublimeVideoPrivateApiController

  # GET /private_api/sites/:site_token/videos/:video_uid/last_video_stats
  def index
    stats = LastVideoStat.where(_args).asc(:time).limit(60)

    if stale?(etag: _args, last_modified: stats.max(:time))
      respond_with(stats: stats)
    end
  end

  private

  def _args
    params.slice(:site_token, :video_uid)
  end
end
