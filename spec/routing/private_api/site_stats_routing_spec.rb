require 'spec_helper'

describe PrivateApi::SiteStatsController do

  specify { expect(get('private_api/sites/1/site_stats/last_days_starts')).to route_to('private_api/site_stats#last_days_starts', site_token: '1') }

end
