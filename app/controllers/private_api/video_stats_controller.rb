class PrivateApi::VideoStatsController < SublimeVideoPrivateApiController

  # GET /private_api/video_stats
  def index
    @stats = VideoStat.last_hours_stats(_args, params[:hours])
    if stale?(etag: params, last_modified: @stats.max(:time))
      respond_with(@stats)
    end
  end

  # GET /private_api/video_stats/last_days_starts
  def last_days_starts
    starts = VideoStat.last_days_starts(_args, params[:days])
    respond_with(starts)
  end

  private

  def _args
    params.slice(:site_token, :video_uid)
  end

end
