class PrivateApi::LastPlaysController < SublimeVideoPrivateApiController

  # GET /private_api/sites/:site_token/last_plays
  # GET /private_api/sites/:site_token/videos/:video_uid/last_plays
  def index
    plays = LastPlay.where(_args).sort(time: -1).limit(5)

    if stale?(etag: _args, last_modified: plays.max(:time))
      respond_with(plays: plays)
    end
  end

  private

  def _args
    params.slice(:site_token, :video_uid)
  end
end
