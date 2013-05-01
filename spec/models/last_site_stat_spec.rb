require 'spec_helper'

describe LastSiteStat do
  it { should be_kind_of Mongoid::Document }
  it { should be_kind_of SiteIdentifiable }
  it { should be_kind_of HourlyExpirable }
  it { should be_kind_of LastStatsable }
end
