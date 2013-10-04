class PrivateApi::LastPlaysController < SublimeVideoPrivateApiController

  # GET /private_api/last_plays
  def index
    @plays = LastPlay.where(_args).desc(:time).limit(3)
    @plays = plays.since(params[:since]) if params.has_key?(:since)
    if stale?(etag: _args, last_modified: @plays.max(:time))
      respond_with(@plays)
    end
  end

  private

  def _args
    params.slice(:site_token, :video_uid)
  end
end
