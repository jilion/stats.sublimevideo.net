require 'spec_helper'

describe PrivateApi::SiteAdminStatsController do

  specify { expect(get('private_api/site_admin_stats')).to route_to('private_api/site_admin_stats#index') }
  specify { expect(get('private_api/site_admin_stats/last_days_starts')).to route_to('private_api/site_admin_stats#last_days_starts') }
  specify { expect(get('private_api/site_admin_stats/last_pages')).to route_to('private_api/site_admin_stats#last_pages') }

end
