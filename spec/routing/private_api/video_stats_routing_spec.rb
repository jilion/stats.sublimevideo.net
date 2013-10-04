require 'spec_helper'

describe PrivateApi::VideoStatsController do

  specify { expect(get('private_api/video_stats')).to route_to('private_api/video_stats#index') }
  specify { expect(get('private_api/video_stats/last_days_starts')).to route_to('private_api/video_stats#last_days_starts') }

end
