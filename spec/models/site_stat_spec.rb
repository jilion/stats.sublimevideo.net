require 'spec_helper'

describe SiteStat do
  it { should be_kind_of Mongoid::Document }
  it { should be_kind_of SiteIdentifiable }
  it { should be_kind_of YearlyExpirable }
  it { should be_kind_of Statsable }
  it { should be_kind_of LastHoursFindable }
  it { should be_kind_of LastDaysStartsFindable }
end
