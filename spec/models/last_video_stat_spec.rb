require 'spec_helper'

describe LastVideoStat do
  it { should be_kind_of Mongoid::Document }
  it { should be_kind_of VideoIdentifiable }
  it { should be_kind_of HourlyExpirable }
  it { should be_kind_of LastStatsable }
end
