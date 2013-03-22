require "spec_helper"

describe VideoStatsSecond do
  it { should be_kind_of Mongoid::Document }
  it { should be_kind_of CustomizedId }
  it { should be_kind_of Statsable }
  it { should be_kind_of ExpirableMinutely }
end
