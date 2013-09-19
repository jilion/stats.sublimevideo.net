require 'fast_spec_helper'

require 'stats_handler_worker'

describe StatsHandlerWorker do
  let(:site_token) { 'site_token' }
  let(:video_uid) { 'video_uid' }
  let(:time) { Time.now.to_i }
  let(:data_hash) { DataHash.new(data) }
  let(:site_args) { { 's' => site_token, 't' => time } }
  let(:video_args) { { 's' => site_token, 'u' => video_uid, 't' => time } }

  before {
    LibratoStatsIncrementer.stub(:increment)
    SiteAdminStatUpserter.stub(:upsert)
    LastPlayCreator.stub(:create)
    LastSiteStat.stub(:upsert_stat)
    LastVideoStat.stub(:upsert_stat)
    SiteStat.stub(:upsert_stats_from_data)
    VideoStat.stub(:upsert_stats_from_data)
  }

  it "delays job in stats queue" do
    StatsHandlerWorker.sidekiq_options_hash['queue'].should eq 'stats'
  end

  context "with video_uid (u) data" do
    let(:data) { {
      's' => site_token,
      'u' => video_uid,
      't' => time,
      'foo' => 'bar',
      'ex' => '1'
    } }

    context "app_load (al) event" do
      it "increments librato stats" do
        LibratoStatsIncrementer.should_receive(:increment).with('al', data_hash)
        StatsHandlerWorker.new.perform('al', data)
      end

      it "upserts site admin stat" do
        SiteAdminStatUpserter.should_receive(:upsert).with(site_args, :app_loads, data_hash)
        StatsHandlerWorker.new.perform('al', data)
      end
    end

    context "load (l) event" do
      it "increments librato stats" do
        LibratoStatsIncrementer.should_receive(:increment).with('l', data_hash)
        StatsHandlerWorker.new.perform('l', data)
      end

      it "upserts last site stat" do
        LastSiteStat.should_receive(:upsert_stat).with(site_args, :loads)
        StatsHandlerWorker.new.perform('l', data)
      end

      it "upserts last video stat" do
        LastVideoStat.should_receive(:upsert_stat).with(video_args, :loads)
        StatsHandlerWorker.new.perform('l', data)
      end

      it "upserts site stat" do
        SiteStat.should_receive(:upsert_stats_from_data).with(site_args, :loads, data_hash)
        StatsHandlerWorker.new.perform('l', data)
      end

      it "upserts video stat" do
        VideoStat.should_receive(:upsert_stats_from_data).with(video_args, :loads, data_hash)
        StatsHandlerWorker.new.perform('l', data)
      end

      it "upserts site admin stat" do
        SiteAdminStatUpserter.should_receive(:upsert).with(site_args, :loads, data_hash)
        StatsHandlerWorker.new.perform('l', data)
      end
    end

    context "start (s) event" do
      it "increments librato stats" do
        LibratoStatsIncrementer.should_receive(:increment).with('s', data_hash)
        StatsHandlerWorker.new.perform('s', data)
      end

      it "creates last play" do
        LastPlayCreator.should_receive(:create).with(data)
        StatsHandlerWorker.new.perform('s', data)
      end

      it "upserts last site stat" do
        LastSiteStat.should_receive(:upsert_stat).with(site_args, :starts)
        StatsHandlerWorker.new.perform('s', data)
      end

      it "upserts last video stat" do
        LastVideoStat.should_receive(:upsert_stat).with(video_args, :starts)
        StatsHandlerWorker.new.perform('s', data)
      end

      it "upserts site stat" do
        SiteStat.should_receive(:upsert_stats_from_data).with(site_args, :starts, data_hash)
        StatsHandlerWorker.new.perform('s', data)
      end

      it "upserts video stat" do
        VideoStat.should_receive(:upsert_stats_from_data).with(video_args, :starts, data_hash)
        StatsHandlerWorker.new.perform('s', data)
      end

      it "upserts site admin stat" do
        SiteAdminStatUpserter.should_receive(:upsert).with(site_args, :starts, data_hash)
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
      it "increments librato stats" do
        LibratoStatsIncrementer.should_receive(:increment).with('al', data_hash)
        StatsHandlerWorker.new.perform('al', data)
      end

      it "upserts site admin stat" do
        SiteAdminStatUpserter.should_receive(:upsert).with(site_args, :app_loads, data_hash)
        StatsHandlerWorker.new.perform('al', data)
      end
    end

    context "load (l) event" do
      it "increments librato stats" do
        LibratoStatsIncrementer.should_receive(:increment).with('l', data_hash)
        StatsHandlerWorker.new.perform('l', data)
      end

      it "doesn't upsert last site stat" do
        LastSiteStat.should_not_receive(:upsert_stat)
        StatsHandlerWorker.new.perform('l', data)
      end

      it "doesn't upsert last video stat" do
        LastVideoStat.should_not_receive(:upsert_stat)
        StatsHandlerWorker.new.perform('l', data)
      end

      it "doesn't upsert site stat" do
        SiteStat.should_not_receive(:upsert_stats_from_data)
        StatsHandlerWorker.new.perform('l', data)
      end

      it "doesn't upsert video stat" do
        VideoStat.should_not_receive(:upsert_stats_from_data)
        StatsHandlerWorker.new.perform('l', data)
      end

      it "upserts site admin stat" do
        SiteAdminStatUpserter.should_receive(:upsert).with(site_args, :loads, data_hash)
        StatsHandlerWorker.new.perform('l', data)
      end
    end

    context "start (s) event" do
      it "increments librato stats" do
        LibratoStatsIncrementer.should_receive(:increment).with('s', data_hash)
        StatsHandlerWorker.new.perform('s', data)
      end

      it "doesn't create last play" do
        LastPlayCreator.should_not_receive(:create)
        StatsHandlerWorker.new.perform('s', data)
      end

      it "doesn't upsert last site stat" do
        LastSiteStat.should_not_receive(:upsert_stat)
        StatsHandlerWorker.new.perform('s', data)
      end

      it "doesn't upsert last video stat" do
        LastVideoStat.should_not_receive(:upsert_stat)
        StatsHandlerWorker.new.perform('s', data)
      end

      it "doesn't upsert site stat" do
        SiteStat.should_not_receive(:upsert_stats_from_data)
        StatsHandlerWorker.new.perform('s', data)
      end

      it "doesn't upsert video stat" do
        VideoStat.should_not_receive(:upsert_stats_from_data)
        StatsHandlerWorker.new.perform('s', data)
      end

      it "upserts site admin stat" do
        SiteAdminStatUpserter.should_receive(:upsert).with(site_args, :starts, data_hash)
        StatsHandlerWorker.new.perform('s', data)
      end
    end
  end
end
