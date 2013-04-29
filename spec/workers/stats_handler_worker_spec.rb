require 'fast_spec_helper'

require 'stats_handler_worker'

describe StatsHandlerWorker do
  let(:site_token) { 'site_token' }
  let(:video_uid) { 'video_uid' }
  let(:time) { Time.now.to_i }

  it "delays job in stats queue" do
    StatsHandlerWorker.sidekiq_options_hash['queue'].should eq 'stats'
  end

  context "load (l) event" do
    let(:data) { {
      's' => site_token,
      'u' => video_uid,
      't' => time
    } }

    it "delays site stat updater worker" do
      LastSiteStatUpdaterWorker.should_receive(:perform_async).with(
        { site_token: site_token, time: time },
        :loads
      )
      StatsHandlerWorker.new.perform('l', data)
    end

    it "delays video stat updater worker" do
      LastVideoStatUpdaterWorker.should_receive(:perform_async).with(
        { site_token: site_token, video_uid: video_uid, time: time },
        :loads
      )
      StatsHandlerWorker.new.perform('l', data)
    end
  end

  context "start (s) event" do
    let(:data) { {
      's' => site_token,
      'u' => video_uid,
      't' => time,
      'foo' => 'bar'
    } }

    it "delays play creator worker" do
      LastPlayCreatorWorker.should_receive(:perform_async).with(data)
      StatsHandlerWorker.new.perform('s', data)
    end

    it "delays site stat updater worker" do
      LastSiteStatUpdaterWorker.should_receive(:perform_async).with(
        { site_token: site_token, time: time },
        :starts
      )
      StatsHandlerWorker.new.perform('s', data)
    end

    it "delays video stat updater worker" do
      LastVideoStatUpdaterWorker.should_receive(:perform_async).with(
        { site_token: site_token, video_uid: video_uid, time: time },
        :starts
      )
      StatsHandlerWorker.new.perform('s', data)
    end
  end
end
