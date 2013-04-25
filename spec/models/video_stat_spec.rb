require 'spec_helper'

describe VideoStat do
  it { should be_kind_of Mongoid::Document }
  it { should be_kind_of Statsable }
end
