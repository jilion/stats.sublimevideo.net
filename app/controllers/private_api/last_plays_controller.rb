class PrivateApi::LastPlaysController < SublimeVideoPrivateApiController

  # GET /private_api/last_plays
  def index
    @plays = LastPlay.where(_args).since(params[:since]).desc(:time).limit(3)
    if stale?(etag: _args, last_modified: @plays.max(:time))
      respond_with(@plays)
    end
  end

  private

  def _args
    params.slice(:site_token, :video_uid)
  end
end
