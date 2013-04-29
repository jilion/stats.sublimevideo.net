require 'spec_helper'

describe LastSiteStat do
  it { should be_kind_of Mongoid::Document }
  it { should be_kind_of HourlyExpirable }
  it { should be_kind_of LastStatsable }
  it { should be_kind_of IncrementableStat }

  it { should have_index_for(s: 1, t: -1) }

  describe ".time_precision" do
    it "precises to the second" do
      LastSiteStat.time_precision.should eq({ seconds: 0 })
    end
  end
end
