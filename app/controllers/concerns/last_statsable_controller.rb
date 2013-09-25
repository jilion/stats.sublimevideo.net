module LastStatsableController

  private

  def _args
    params.slice(:site_token, :video_uid)
  end

  def _last_modified
    params.key?(:since) ? Time.at(params[:since].to_i) : @stats.max(:time)
  end

end
