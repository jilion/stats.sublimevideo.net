module LastStatsableController

  private

  def _args
    params.slice(:site_token, :video_uid)
  end

  def _last_modified
    @stats.max(:updated_at)
  end

end
