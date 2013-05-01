require 'fast_spec_helper'

require 'video_stat_updater_worker'

describe VideoStatUpdaterWorker do
  it "delays job in stats queue" do
    VideoStatUpdaterWorker.sidekiq_options_hash['queue'].should eq 'stats'
  end

  describe ".perform" do
    let(:video_args) { { site_token: 'site_token', video_uid: 'video_uid', time: Time.now.to_i } }
    let(:data) { { foo: 'bar' } }

    it "increments stats on VideoStat" do
      VideoStat.should_receive(:inc_stats).with(video_args, data)
      VideoStatUpdaterWorker.new.perform(video_args, data)
    end
  end
end
