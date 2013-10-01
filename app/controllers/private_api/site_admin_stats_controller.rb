class PrivateApi::SiteAdminStatsController < SublimeVideoPrivateApiController

  # GET /private_api/sites/:site_token/site_admin_stats
  def index
    stats = SiteAdminStat.where(_args).asc(:time)
    stats = stats.page(params[:page]).per(params[:per])
    stats = stats.last_days(params[:days].to_i) if params.key?(:days)

    if stale?(etag: params, last_modified: stats.max(:time))
      respond_with(stats)
    end
  end

  # GET /private_api/sites/:site_token/site_admin_stats/last_days_starts
  def last_days_starts
    starts = SiteAdminStat.last_days_starts(_args, params[:days])

    respond_with(starts: starts)
  end

  # GET /private_api/sites/:site_token/site_admin_stats/last_pages
  def last_pages
    pages = SiteAdminStat.last_pages(params[:site_token], params.slice(:days, :limit))

    if stale?(etag: params)
      expires_in 1.hour, public: true
      respond_with(pages: pages)
    end
  end

  private

  def _args
    params.slice(:site_token)
  end

end
