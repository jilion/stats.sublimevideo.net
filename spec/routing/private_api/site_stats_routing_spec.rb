require 'spec_helper'

describe PrivateApi::SiteStatsController do

  specify { expect(get('private_api/sites/1/site_stats')).to route_to('private_api/site_stats#index', site_token: '1') }
  specify { expect(get('private_api/sites/1/site_stats/last_days_starts')).to route_to('private_api/site_stats#last_days_starts', site_token: '1') }

end
