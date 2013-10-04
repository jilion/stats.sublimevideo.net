require 'spec_helper'

describe PrivateApi::SiteStatsController do

  specify { expect(get('private_api/site_stats')).to route_to('private_api/site_stats#index') }
  specify { expect(get('private_api/site_stats/last_days_starts')).to route_to('private_api/site_stats#last_days_starts') }

end
