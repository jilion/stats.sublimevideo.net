require 'fast_spec_helper'
require 'config/sidekiq'

require 'stats_handler_worker'

describe StatsHandlerWorker do
  let(:site_token) { 'site_token' }
  let(:video_uid) { 'video_uid' }
  let(:time) { Time.now.to_i }

  it "delays job in stats queue" do
    StatsHandlerWorker.sidekiq_options_hash['queue'].should eq 'stats'
  end

  let(:librato_stats_incrementer_worker) { double(LibratoStatsIncrementerWorker, perform: true) }
  let(:last_play_creator_worker) { double(LastPlayCreatorWorker, perform: true) }
  let(:last_site_stat_updater_worker) { double(LastSiteStatUpdaterWorker, perform: true) }
  let(:last_video_stat_updater_worker) { double(LastVideoStatUpdaterWorker, perform: true) }
  let(:site_stat_updater_worker) { double(SiteStatUpdaterWorker, perform: true) }
  let(:video_stat_updater_worker) { double(VideoStatUpdaterWorker, perform: true) }
  let(:site_admin_stat_updater_worker) { double(SiteAdminStatUpdaterWorker, perform: true) }

  before {
    LibratoStatsIncrementerWorker.stub(:new) { librato_stats_incrementer_worker }
    LastPlayCreatorWorker.stub(:new) { last_play_creator_worker }
    LastSiteStatUpdaterWorker.stub(:new) { last_site_stat_updater_worker }
    LastVideoStatUpdaterWorker.stub(:new) { last_video_stat_updater_worker }
    SiteStatUpdaterWorker.stub(:new) { site_stat_updater_worker }
    VideoStatUpdaterWorker.stub(:new) { video_stat_updater_worker }
    SiteAdminStatUpdaterWorker.stub(:new) { site_admin_stat_updater_worker }
  }

  context "with video_uid (u) data" do
    let(:data) { {
      's' => site_token,
      'u' => video_uid,
      't' => time,
      'foo' => 'bar',
      'ex' => '1'
    } }

    context "app_load (al) event" do
      it "performs librato stats incrementer worker" do
        librato_stats_incrementer_worker.should_receive(:perform).with('al',data)
        StatsHandlerWorker.new.perform('al', data)
      end

      it "performs site admin stat updater worker" do
        site_admin_stat_updater_worker.should_receive(:perform).with(
          { site_token: site_token, time: time },
          :app_loads,
          data)
        StatsHandlerWorker.new.perform('al', data)
      end
    end

    context "load (l) event" do
      it "performs librato stats incrementer worker" do
        librato_stats_incrementer_worker.should_receive(:perform).with('l',data)
        StatsHandlerWorker.new.perform('l', data)
      end

      it "performs last site stat updater worker" do
        last_site_stat_updater_worker.should_receive(:perform).with(
          { site_token: site_token, time: time },
          :loads)
        StatsHandlerWorker.new.perform('l', data)
      end

      it "performs last video stat updater worker" do
        last_video_stat_updater_worker.should_receive(:perform).with(
          { site_token: site_token, video_uid: video_uid, time: time },
          :loads)
        StatsHandlerWorker.new.perform('l', data)
      end

      it "performs site stat updater worker" do
        site_stat_updater_worker.should_receive(:perform).with(
          { site_token: site_token, time: time },
          :loads,
          'foo' => 'bar', 'ex' => '1')
        StatsHandlerWorker.new.perform('l', data)
      end

      it "performs video stat updater worker" do
        video_stat_updater_worker.should_receive(:perform).with(
          { site_token: site_token, video_uid: video_uid, time: time },
          :loads,
          'foo' => 'bar', 'ex' => '1')
        StatsHandlerWorker.new.perform('l', data)
      end

      it "performs site admin stat updater worker" do
        site_admin_stat_updater_worker.should_receive(:perform).with(
          { site_token: site_token, time: time },
          :loads,
          'foo' => 'bar', 'ex' => '1')
        StatsHandlerWorker.new.perform('l', data)
      end
    end

    context "start (s) event" do
      it "performs librato stats incrementer worker" do
        librato_stats_incrementer_worker.should_receive(:perform).with('s',data)
        StatsHandlerWorker.new.perform('s', data)
      end

      it "performs play creator worker" do
        last_play_creator_worker.should_receive(:perform).with(data)
        StatsHandlerWorker.new.perform('s', data)
      end

      it "performs last site stat updater worker" do
        last_site_stat_updater_worker.should_receive(:perform).with(
          { site_token: site_token, time: time },
          :starts)
        StatsHandlerWorker.new.perform('s', data)
      end

      it "performs last video stat updater worker" do
        last_video_stat_updater_worker.should_receive(:perform).with(
          { site_token: site_token, video_uid: video_uid, time: time },
          :starts)
        StatsHandlerWorker.new.perform('s', data)
      end

      it "performs site stat updater worker" do
        site_stat_updater_worker.should_receive(:perform).with(
          { site_token: site_token, time: time },
          :starts,
          'foo' => 'bar', 'ex' => '1')
        StatsHandlerWorker.new.perform('s', data)
      end

      it "performs video stat updater worker" do
        video_stat_updater_worker.should_receive(:perform).with(
          { site_token: site_token, video_uid: video_uid, time: time },
          :starts,
          'foo' => 'bar', 'ex' => '1')
        StatsHandlerWorker.new.perform('s', data)
      end

      it "performs site admin stat updater worker" do
        site_admin_stat_updater_worker.should_receive(:perform).with(
          { site_token: site_token, time: time },
          :starts,
          'foo' => 'bar', 'ex' => '1')
        StatsHandlerWorker.new.perform('s', data)
      end
    end
  end

  context "without video_uid (u) data" do
    let(:data) { {
      's' => site_token,
      't' => time,
      'foo' => 'bar',
      'ex' => '1'
    } }

    context "app_load (al) event" do
      it "performs librato stats incrementer worker" do
        librato_stats_incrementer_worker.should_receive(:perform).with('al',data)
        StatsHandlerWorker.new.perform('al', data)
      end

      it "performs site admin stat updater worker" do
        site_admin_stat_updater_worker.should_receive(:perform).with(
          { site_token: site_token, time: time },
          :app_loads,
          data)
        StatsHandlerWorker.new.perform('al', data)
      end
    end

    context "load (l) event" do
      it "performs librato stats incrementer worker" do
        librato_stats_incrementer_worker.should_receive(:perform).with('l',data)
        StatsHandlerWorker.new.perform('l', data)
      end

      it "doesn't perform last site stat updater worker" do
        last_site_stat_updater_worker.should_not_receive(:perform)
        StatsHandlerWorker.new.perform('l', data)
      end

      it "doesn't perform last video stat updater worker" do
        last_video_stat_updater_worker.should_not_receive(:perform)
        StatsHandlerWorker.new.perform('l', data)
      end

      it "doesn't perform site stat updater worker" do
        site_stat_updater_worker.should_not_receive(:perform)
        StatsHandlerWorker.new.perform('l', data)
      end

      it "doesn't perform video stat updater worker" do
        video_stat_updater_worker.should_not_receive(:perform)
        StatsHandlerWorker.new.perform('l', data)
      end

      it "performs site admin stat updater worker" do
        site_admin_stat_updater_worker.should_receive(:perform).with(
          { site_token: site_token, time: time },
          :loads,
          'foo' => 'bar', 'ex' => '1')
        StatsHandlerWorker.new.perform('l', data)
      end
    end

    context "start (s) event" do
      it "performs librato stats incrementer worker" do
        librato_stats_incrementer_worker.should_receive(:perform).with('s',data)
        StatsHandlerWorker.new.perform('s', data)
      end

      it "doesn't perform play creator worker" do
        last_play_creator_worker.should_not_receive(:perform)
        StatsHandlerWorker.new.perform('s', data)
      end

      it "doesn't perform last site stat updater worker" do
        last_site_stat_updater_worker.should_not_receive(:perform)
        StatsHandlerWorker.new.perform('s', data)
      end

      it "doesn't perform last video stat updater worker" do
        last_video_stat_updater_worker.should_not_receive(:perform)
        StatsHandlerWorker.new.perform('s', data)
      end

      it "doesn't perform site stat updater worker" do
        site_stat_updater_worker.should_not_receive(:perform)
        StatsHandlerWorker.new.perform('s', data)
      end

      it "doesn't perform video stat updater worker" do
        video_stat_updater_worker.should_not_receive(:perform)
        StatsHandlerWorker.new.perform('s', data)
      end

      it "performs site admin stat updater worker" do
        site_admin_stat_updater_worker.should_receive(:perform).with(
          { site_token: site_token, time: time },
          :starts,
          'foo' => 'bar', 'ex' => '1')
        StatsHandlerWorker.new.perform('s', data)
      end
    end
  end
end
