class LastPlaysController < ActionController::Base
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

  def _set_response_headers
    response.headers['Access-Control-Allow-Origin'] = '*'
    response.headers['Content-Type'] = 'text/event-stream'
  end
end
