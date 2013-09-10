class PrivateApi::VideoStatsController < SublimeVideoPrivateApiController

  # GET /private_api/sites/:site_token/video_stats/:id
  def show
    stats = VideoStat.last_hours_stats({ site_token: params[:site_token], video_uid: params[:id] },
                                        params[:hours].to_i)
    respond_with(stats: stats)
  end

  # GET /private_api/sites/:site_token/video_stats/:id/last_days_starts
  def last_days_starts
    starts = VideoStat.last_days_starts({ site_token: params[:site_token], video_uid: params[:id] },
                                        params[:days].to_i)
    respond_with(starts: starts)
  end
end
