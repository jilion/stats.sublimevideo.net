require 'spec_helper'

describe PrivateApi::LastSiteStatsController do

  specify { expect(get('private_api/sites/1/last_site_stats')).to route_to('private_api/last_site_stats#index', site_token: '1') }

end
