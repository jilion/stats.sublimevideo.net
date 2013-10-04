require 'spec_helper'

describe PrivateApi::SiteAdminStatsController do

  specify { expect(get('private_api/site_admin_stats')).to route_to('private_api/site_admin_stats#index') }
  specify { expect(get('private_api/site_admin_stats/last_days_starts')).to route_to('private_api/site_admin_stats#last_days_starts') }
  specify { expect(get('private_api/site_admin_stats/last_pages')).to route_to('private_api/site_admin_stats#last_pages') }
  specify { expect(get('private_api/site_admin_stats/global_day_stat')).to route_to('private_api/site_admin_stats#global_day_stat') }
  specify { expect(get('private_api/site_admin_stats/last_30_days_sites_with_starts')).to route_to('private_api/site_admin_stats#last_30_days_sites_with_starts') }

end
