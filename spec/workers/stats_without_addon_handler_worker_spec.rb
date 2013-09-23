require 'fast_spec_helper'

require 'stats_without_addon_handler_worker'

describe StatsWithoutAddonHandlerWorker do
  let(:site_token) { 'site_token' }
  let(:video_uid) { 'video_uid' }
  let(:time) { Time.now.to_i }
  let(:data_hash) { DataHash.new(data) }
  let(:site_args) { { 's' => site_token, 't' => time } }
  let(:video_args) { { 's' => site_token, 'u' => video_uid, 't' => time } }
  let(:data) { {
    's' => site_token,
    'u' => video_uid,
    't' => time,
    'foo' => 'bar',
    'ex' => '1'
  } }

  before {
    LibratoStatsIncrementer.stub(:increment)
    SiteAdminStatUpserter.stub(:upsert)
  }

  it "delays job in stats queue" do
    expect(StatsWithoutAddonHandlerWorker.sidekiq_options_hash['queue']).to eq 'stats-slow'
  end

  context "app_load (al) event" do
    after { StatsWithoutAddonHandlerWorker.new.perform('al', data) }

    specify { expect(LibratoStatsIncrementer).to receive(:increment).with('al', data_hash) }
    specify { expect(SiteAdminStatUpserter).to receive(:upsert).with(site_args, :app_loads, data_hash) }
  end

  context "load (l) event" do
    after { StatsWithoutAddonHandlerWorker.new.perform('l', data) }

    specify { expect(LibratoStatsIncrementer).to receive(:increment).with('l', data_hash) }
    specify { expect(SiteAdminStatUpserter).to receive(:upsert).with(site_args, :loads, data_hash) }
  end

  context "start (s) event" do
    after { StatsWithoutAddonHandlerWorker.new.perform('s', data) }

    specify { expect(LibratoStatsIncrementer).to receive(:increment).with('s', data_hash) }
    specify { expect(SiteAdminStatUpserter).to receive(:upsert).with(site_args, :starts, data_hash) }
  end

end
