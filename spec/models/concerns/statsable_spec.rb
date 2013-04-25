require 'fast_spec_helper'
require 'config/mongoid'

require 'statsable'

describe Statsable do
  class StatsableModel
    include Mongoid::Document
    include Statsable
  end
  subject { StatsableModel }

  it { should have_field(:lo).with_alias(:loads).of_type(Hash) }
  it { should have_field(:st).with_alias(:starts).of_type(Hash) }
  it { should have_field(:de).with_alias(:devices).of_type(Hash) }
  it { should have_field(:co).with_alias(:countries).of_type(Hash) }
  it { should have_field(:bp).with_alias(:browser_and_platform).of_type(Hash) }
end
