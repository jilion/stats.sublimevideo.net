require 'spec_helper'

describe VideoStat do
  it { should be_kind_of Mongoid::Document }
  it { should be_kind_of VideoIdentifiable }
  it { should be_kind_of YearlyExpirable }
  it { should be_kind_of Statsable }
  it { should be_kind_of LastHoursFindable }
  it { should be_kind_of LastDaysStartsFindable }
end
