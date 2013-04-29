require 'fast_spec_helper'

require 'last_video_stat_updater_worker'

describe LastVideoStatUpdaterWorker do
  it "delays job in stats queue" do
    LastVideoStatUpdaterWorker.sidekiq_options_hash['queue'].should eq 'stats'
  end

  describe ".perform" do
    let(:video_args) { { site_token: 'site_token', video_uid: 'video_uid', time: Time.now.to_i } }

    it "increments stat on LastVideoStat" do
      LastVideoStat.should_receive(:inc_stat).with(video_args, :loads)
      LastVideoStatUpdaterWorker.new.perform(video_args, :loads)
    end
  end
end
