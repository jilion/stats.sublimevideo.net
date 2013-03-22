require 'fast_spec_helper'
require 'config/mongoid'

require 'statsable'

describe Statsable do
  class StatsableModel
    include Mongoid::Document
    include Statsable
  end
  subject { StatsableModel }

  it { should have_field(:vl).with_alias(:video_loads).of_type(Hash) }
  it { should have_field(:vs).with_alias(:video_starts).of_type(Hash) }
  it { should have_field(:td).with_alias(:tech_by_device).of_type(Hash) }
  it { should have_field(:bp).with_alias(:browser_and_plateform).of_type(Hash) }
end
