require 'spec_helper'

describe PrivateApi::LastPlaysController do

  specify { expect(get('private_api/last_plays')).to route_to('private_api/last_plays#index') }

end
