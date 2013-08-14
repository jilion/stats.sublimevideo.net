require 'fast_spec_helper'

require 'librato_stats_incrementer_worker'

describe LibratoStatsIncrementerWorker do
  it "delays job in stats queue" do
    LibratoStatsIncrementerWorker.sidekiq_options_hash['queue'].should eq 'stats'
  end

  describe ".perform" do
    let(:data_hash) { double('dataHash',
      country_code: 'ch',
      browser_code: 'saf',
      platform_code: 'osx'
    ) }
    before { DataHash.stub(:new) { data_hash } }

    context "app load (al) event" do
      let(:event_key) { 'al' }
      before {
        data_hash.stub(:hostname) { 'main' }
        data_hash.stub(:ss) { '1' }
        data_hash.stub(:stage) { 'stable' }
        data_hash.stub(:fv) { '1.0.0' }
        data_hash.stub(:jq) { '2.0.0' }
        data_hash.stub(:sr) { '2400x1920' }
        data_hash.stub(:sd) { '180' }
        data_hash.stub(:bl) { 'ch-fr' }
      }

      it "increments app load stats" do
        Librato.should_receive(:increment).with('data.app_load.country', source: 'ch')
        Librato.should_receive(:increment).with('data.app_load.browser', source: 'saf')
        Librato.should_receive(:increment).with('data.app_load.platform', source: 'osx')
        Librato.should_receive(:increment).with('data.app_load.hostname', source: 'main')
        Librato.should_receive(:increment).with('data.app_load.ssl', source: 'on')
        Librato.should_receive(:increment).with('data.app_load.stage', source: 'stable')
        Librato.should_receive(:increment).with('data.app_load.flash_version', source: '1.0.0')
        Librato.should_receive(:increment).with('data.app_load.jquery_version', source: '2.0.0')
        Librato.should_receive(:increment).with('data.app_load.screen_resolution', source: '2400x1920')
        Librato.should_receive(:increment).with('data.app_load.screen_dpr', source: '180')
        Librato.should_receive(:increment).with('data.app_load.browser_language', source: 'ch-fr')
        LibratoStatsIncrementerWorker.new.perform(event_key, {})
      end
    end

    context "load (l) event" do
      let(:event_key) { 'l' }
      before {
        data_hash.stub(:device) { 'mobile' }
        data_hash.stub(:tech) { 'html' }
        data_hash.stub(:source) { 'external' }
        data_hash.stub(:em) { '1' }
      }

      it "increments load stats" do
        Librato.should_receive(:increment).with('data.load.country', source: 'ch')
        Librato.should_receive(:increment).with('data.load.browser', source: 'saf')
        Librato.should_receive(:increment).with('data.load.platform', source: 'osx')
        Librato.should_receive(:increment).with('data.load.device', source: 'mobile')
        Librato.should_receive(:increment).with('data.load.tech', source: 'html')
        Librato.should_receive(:increment).with('data.load.source', source: 'external')
        Librato.should_receive(:increment).with('data.load.embedded', source: 'true')
        LibratoStatsIncrementerWorker.new.perform(event_key, {})
      end
    end

    context "start (s) event" do
      let(:event_key) { 's' }
      before {
        data_hash.stub(:device) { 'desktop' }
        data_hash.stub(:tech) { 'flash' }
        data_hash.stub(:source) { 'website' }
        data_hash.stub(:em) { nil }
      }

      it "increments start stats" do
        Librato.should_receive(:increment).with('data.start.country', source: 'ch')
        Librato.should_receive(:increment).with('data.start.browser', source: 'saf')
        Librato.should_receive(:increment).with('data.start.platform', source: 'osx')
        Librato.should_receive(:increment).with('data.start.device', source: 'desktop')
        Librato.should_receive(:increment).with('data.start.tech', source: 'flash')
        Librato.should_receive(:increment).with('data.start.source', source: 'website')
        Librato.should_receive(:increment).with('data.start.embedded', source: 'false')
        LibratoStatsIncrementerWorker.new.perform(event_key, {})
      end
    end
  end
end
