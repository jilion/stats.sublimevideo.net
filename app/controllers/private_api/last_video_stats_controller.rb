class PrivateApi::LastVideoStatsController < SublimeVideoPrivateApiController
  include LastStatsableController

  # GET /private_api/last_video_stats
  def index
    @stats = LastVideoStat.where(_args).desc(:time).limit(60)
    if stale?(etag: _args, last_modified: _last_modified)
      respond_with(@stats)
    end
  end

end
