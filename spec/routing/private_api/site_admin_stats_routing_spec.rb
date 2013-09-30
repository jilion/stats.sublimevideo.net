require 'spec_helper'

describe PrivateApi::SiteAdminStatsController do

  specify { expect(get('private_api/sites/1/site_admin_stats')).to route_to('private_api/site_admin_stats#index', site_token: '1') }
  specify { expect(get('private_api/sites/1/site_admin_stats/last_days_starts')).to route_to('private_api/site_admin_stats#last_days_starts', site_token: '1') }
  specify { expect(get('private_api/sites/1/site_admin_stats/last_pages')).to route_to('private_api/site_admin_stats#last_pages', site_token: '1') }

end
