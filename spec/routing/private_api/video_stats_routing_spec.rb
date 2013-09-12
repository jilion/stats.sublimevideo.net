require 'spec_helper'

describe PrivateApi::VideoStatsController do

  specify { expect(get('private_api/sites/1/videos/2/video_stats')).to route_to('private_api/video_stats#index', site_token: '1', video_uid: '2') }
  specify { expect(get('private_api/sites/1/videos/2/video_stats/last_days_starts')).to route_to('private_api/video_stats#last_days_starts', site_token: '1', video_uid: '2') }

end
