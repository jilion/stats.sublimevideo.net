require 'spec_helper'

describe LastSiteStat do
  it { should be_kind_of Mongoid::Document }
  it { should be_kind_of LastStatsable }

  it { should have_index_for(s: 1, t: -1) }
  it { should have_index_for(t: 1).with_options(expireAfterSeconds: 61.minutes.to_i) }

  describe ".inc_stat" do
    let(:site_token) { 'site_token' }
    let(:time) { Time.now.to_i }

    it "creates stat if not present" do
      LastSiteStat.inc_stat(site_token, time, :loads)
      stat = LastSiteStat.last
      stat.site_token.should eq site_token
      stat.time.should eq Time.at(time).change(seconds: 0)
      stat.loads.should eq 1
    end

    it "increments stat if present" do
      LastSiteStat.inc_stat(site_token, time, :loads)
      LastSiteStat.inc_stat(site_token, time, :loads)
      LastSiteStat.count.should eq 1
      LastSiteStat.last.loads.should eq 2
    end
  end
end
