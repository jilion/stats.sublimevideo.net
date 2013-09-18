class PrivateApi::VideoStatsController < SublimeVideoPrivateApiController

  # GET /private_api/sites/:site_token/videos/:video_uid/video_stats
  def index
    stats = VideoStat.last_hours_stats(_args, params[:hours].to_i)

    if stale?(etag: params, last_modified: stats.max(:time))
      respond_with(stats: stats)
    end
  end

  # GET /private_api/sites/:site_token/videos/:video_uid/video_stats/last_days_starts
  def last_days_starts
    starts = VideoStat.last_days_starts(_args, params[:days].to_i)

    respond_with(starts: starts)
  end

  private

  def _args
    params.slice(:site_token, :video_uid)
  end
end
