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
    expect(StatsHandlerWorker.sidekiq_options_hash['queue']).to eq 'stats'
  end

  context "with stats_addon & video_uid (u) data" do
    let(:data) { {
      's' => site_token,
      'u' => video_uid,
      't' => time,
      'sa' => '1',
      'foo' => 'bar',
      'ex' => '1'
    } }

    context "app_load (al) event" do
      after { StatsHandlerWorker.new.perform('al', data) }

      specify { expect(LibratoStatsIncrementer).to receive(:increment).with('al', data_hash) }
      specify { expect(SiteAdminStatUpserter).to receive(:upsert).with(site_args, :app_loads, data_hash) }
    end

    context "load (l) event" do
      after { StatsHandlerWorker.new.perform('l', data) }

      specify { expect(LibratoStatsIncrementer).to receive(:increment).with('l', data_hash) }
      specify { expect(LastSiteStat).to receive(:upsert_stat).with(site_args, :loads) }
      specify { expect(LastVideoStat).to receive(:upsert_stat).with(video_args, :loads) }
      specify { expect(SiteStat).to receive(:upsert_stats_from_data).with(site_args, :loads, data_hash) }
      specify { expect(VideoStat).to receive(:upsert_stats_from_data).with(video_args, :loads, data_hash) }
      specify { expect(SiteAdminStatUpserter).to receive(:upsert).with(site_args, :loads, data_hash) }
    end

    context "start (s) event" do
      after { StatsHandlerWorker.new.perform('s', data) }

      specify { expect(LibratoStatsIncrementer).to receive(:increment).with('s', data_hash) }
      specify { expect(LastPlayCreator).to receive(:create).with(data) }
      specify { expect(LastSiteStat).to receive(:upsert_stat).with(site_args, :starts) }
      specify { expect(LastVideoStat).to receive(:upsert_stat).with(video_args, :starts) }
      specify { expect(SiteStat).to receive(:upsert_stats_from_data).with(site_args, :starts, data_hash) }
      specify { expect(VideoStat).to receive(:upsert_stats_from_data).with(video_args, :starts, data_hash) }
      specify { expect(SiteAdminStatUpserter).to receive(:upsert).with(site_args, :starts, data_hash) }
    end
  end

  context "without stats_addon & video_uid (u) data" do
    let(:data) { {
      's' => site_token,
      't' => time,
      'foo' => 'bar',
      'ex' => '1'
    } }

    context "app_load (al) event" do
      after { StatsHandlerWorker.new.perform('al', data) }

      specify { expect(LibratoStatsIncrementer).to receive(:increment).with('al', data_hash) }
      specify { expect(SiteAdminStatUpserter).to receive(:upsert).with(site_args, :app_loads, data_hash) }
    end

    context "load (l) event" do
      after { StatsHandlerWorker.new.perform('l', data) }

      specify { expect(LibratoStatsIncrementer).to receive(:increment).with('l', data_hash) }
      specify { expect(LastSiteStat).to_not receive(:upsert_stat).with(site_args, :loads) }
      specify { expect(LastVideoStat).to_not receive(:upsert_stat).with(video_args, :loads) }
      specify { expect(SiteStat).to_not receive(:upsert_stats_from_data).with(site_args, :loads, data_hash) }
      specify { expect(VideoStat).to_not receive(:upsert_stats_from_data).with(video_args, :loads, data_hash) }
      specify { expect(SiteAdminStatUpserter).to receive(:upsert).with(site_args, :loads, data_hash) }
    end

    context "start (s) event" do
      after { StatsHandlerWorker.new.perform('s', data) }

      specify { expect(LibratoStatsIncrementer).to receive(:increment).with('s', data_hash) }
      specify { expect(LastPlayCreator).to_not receive(:create).with(data) }
      specify { expect(LastSiteStat).to_not receive(:upsert_stat).with(site_args, :starts) }
      specify { expect(LastVideoStat).to_not receive(:upsert_stat).with(video_args, :starts) }
      specify { expect(SiteStat).to_not receive(:upsert_stats_from_data).with(site_args, :starts, data_hash) }
      specify { expect(VideoStat).to_not receive(:upsert_stats_from_data).with(video_args, :starts, data_hash) }
      specify { expect(SiteAdminStatUpserter).to receive(:upsert).with(site_args, :starts, data_hash) }
    end
  end
end
