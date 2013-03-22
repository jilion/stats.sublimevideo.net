require 'spec_helper'

describe SiteStatsDay do
  it { should be_kind_of Mongoid::Document }
  it { should be_kind_of CustomizedId }
  it { should be_kind_of Statsable }
end
