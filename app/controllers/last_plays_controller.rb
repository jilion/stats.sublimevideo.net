class LastPlaysController < ActionController::Base
  before_action :_verify_site_token_and_video_uid, only: :index

  include ActionController::Live

  # GET /plays
  def index
    _set_response_headers

    sse = SSE.new(response.stream)
    watcher = PlayWatcher.new(params[:site_token], params[:video_uid])

    watcher.on_play do |time|
      sse.write(time.to_i)
    end
  rescue IOError
    # When the client disconnects, we'll get an IOError on write
  ensure
    sse.close
  end

  private

  def _verify_site_token_and_video_uid
    key = params[:auth].decrypt(:symmetric)
    matches = key.match(/([a-z0-9]{8}):(.*)/)
    @site_token = matches[1]
    @video_uid = matches[2]
  rescue
    render status: 401
  end

  def _set_response_headers
    response.headers['Access-Control-Allow-Origin'] = '*'
    response.headers['Content-Type'] = 'text/event-stream'
  end
end
