require 'spec_helper'

describe LastSiteStat do
  it { should be_kind_of Mongoid::Document }
  it { should be_kind_of LastStatsable }

  it { should have_index_for(t: 1).with_options(expireAfterSeconds: 61.minutes.to_i) }
end
