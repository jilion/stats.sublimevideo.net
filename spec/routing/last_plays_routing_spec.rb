require 'spec_helper'

describe LastPlaysController do

  it { expect(get('plays')).to route_to('last_plays#index') }

end
