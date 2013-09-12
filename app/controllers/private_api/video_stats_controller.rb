class PrivateApi::VideoStatsController < SublimeVideoPrivateApiController

  # GET /private_api/sites/:site_token/videos/:video_uid/video_stats
  def index
    stats = VideoStat.last_hours_stats(_video_args, params[:hours].to_i)

    respond_with(stats: stats)
  end

  # GET /private_api/sites/:site_token/videos/:video_uid/video_stats/last_days_starts
  def last_days_starts
    starts = VideoStat.last_days_starts(_video_args, params[:days].to_i)

    respond_with(starts: starts)
  end

  private

  def _video_args
    { site_token: params[:site_token], video_uid: params[:video_uid] }
  end
end
