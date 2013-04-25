require 'fast_spec_helper'
require 'config/mongoid'

require 'last_statsable'

describe LastStatsable do
  class LastStatsableModel
    include Mongoid::Document
    include LastStatsable
  end
  subject { LastStatsableModel }

  it { should have_field(:lo).with_alias(:loads).of_type(Integer) }
  it { should have_field(:st).with_alias(:starts).of_type(Integer) }
end
