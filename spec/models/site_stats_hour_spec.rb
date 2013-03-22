require 'spec_helper'

describe SiteStatsHour do
  it { should be_kind_of Mongoid::Document }
  it { should be_kind_of CustomizedId }
  it { should be_kind_of Statsable }
  it { should be_kind_of ExpirableDaily }
end
