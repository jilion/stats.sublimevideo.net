require 'spec_helper'

describe SiteStat do
  it { should be_kind_of Mongoid::Document }
  it { should be_kind_of SiteIdentifiable }
  it { should be_kind_of Statsable }
end
