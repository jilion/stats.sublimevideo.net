require 'spec_helper'

describe PrivateApi::LastVideoStatsController do

  specify { expect(get('private_api/sites/1/videos/2/last_video_stats')).to route_to('private_api/last_video_stats#index', site_token: '1', video_uid: '2') }

end
