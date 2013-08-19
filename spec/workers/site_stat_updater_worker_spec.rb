require 'fast_spec_helper'

require 'site_stat_updater_worker'

describe SiteStatUpdaterWorker do
  it "delays job in stats queue" do
    SiteStatUpdaterWorker.sidekiq_options_hash['queue'].should eq 'stats'
  end

  describe ".perform" do
    let(:site_args) { { site_token: 'site_token', time: Time.now.to_i } }
    let(:data) { { foo: 'bar' } }

    it "increments stats on SiteStat" do
      SiteStat.should_receive(:inc_stats).with(site_args, :loads, data)
      SiteStatUpdaterWorker.new.perform(site_args, 'loads', data)
    end
  end
end
