require 'spec_helper'

describe PrivateApi::LastVideoStatsController do

  specify { expect(get('private_api/last_video_stats')).to route_to('private_api/last_video_stats#index') }

end
