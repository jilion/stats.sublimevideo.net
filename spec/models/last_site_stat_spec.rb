require 'spec_helper'

describe LastSiteStat do
  it { should be_kind_of Mongoid::Document }
  it { should be_kind_of LastStatsable }
  it { should be_kind_of IncrementableStat }

  it { should have_index_for(s: 1, t: -1) }
  it { should have_index_for(t: 1).with_options(expireAfterSeconds: 61.minutes.to_i) }

  describe ".time_precision" do
    it "precises to the second" do
      LastSiteStat.time_precision.should eq({ seconds: 0 })
    end
  end
end
