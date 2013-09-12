require 'spec_helper'

describe PrivateApi::LastPlaysController do

  specify { expect(get('private_api/sites/1/last_plays')).to route_to('private_api/last_plays#index', site_token: '1') }
  specify { expect(get('private_api/sites/1/videos/2/last_plays')).to route_to('private_api/last_plays#index', site_token: '1', video_uid: '2') }

end
