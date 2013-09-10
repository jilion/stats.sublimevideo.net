class SSE

  def initialize(io)
    @io = io
    _keep_connection_open
  end

  def write(object, options = {})
    options.each { |k,v| @io.write "#{k}: #{v}\n" }
    @io.write "data: #{MultiJson.dump(object)}\n\n"
  end

  def close
    @heartbeat_thread.exit
    @io.close
  end

  private

  def _keep_connection_open
    @heartbeat_thread = Thread.new do
      loop do
        write({}, event: 'heartbeat')
        sleep 15
      end
    end
  end
end
