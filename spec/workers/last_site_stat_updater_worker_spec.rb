require 'fast_spec_helper'

require 'last_site_stat_updater_worker'

describe LastSiteStatUpdaterWorker do
  it "delays job in stats queue" do
    LastSiteStatUpdaterWorker.sidekiq_options_hash['queue'].should eq 'stats'
  end

  describe ".perform" do
    let(:site_args) { { site_token: 'site_token', time: Time.now.to_i } }

    it "increments stat on LastSiteStat" do
      LastSiteStat.should_receive(:inc_stat).with(site_args, :loads)
      LastSiteStatUpdaterWorker.new.perform(site_args, :loads)
    end
  end
end
