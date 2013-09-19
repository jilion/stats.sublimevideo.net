require 'fast_spec_helper'

require 'librato_stats_incrementer'

describe LibratoStatsIncrementer do
  let(:icrementer) { LibratoStatsIncrementer.new(event_key, data) }
  describe "#increment" do
    let(:data) { double('dataHash',
      country_code: 'ch',
      browser_code: 'saf',
      platform_code: 'osx'
    ) }

    context "app load (al) event" do
      let(:event_key) { 'al' }
      before {
        data.stub(:hostname) { 'main' }
        data.stub(:ss) { '1' }
        data.stub(:stage) { 'stable' }
        data.stub(:fv) { '1.0.0' }
        data.stub(:jq) { '2.0.0' }
        data.stub(:sr) { '2400x1920' }
        data.stub(:sd) { '180' }
        data.stub(:bl) { 'ch-fr' }
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
        icrementer.increment
      end
    end

    context "load (l) event" do
      let(:event_key) { 'l' }
      before {
        data.stub(:device) { 'mobile' }
        data.stub(:tech) { 'html' }
        data.stub(:source) { 'external' }
        data.stub(:em) { '1' }
      }

      it "increments load stats" do
        Librato.should_receive(:increment).with('data.load.country', source: 'ch')
        Librato.should_receive(:increment).with('data.load.browser', source: 'saf')
        Librato.should_receive(:increment).with('data.load.platform', source: 'osx')
        Librato.should_receive(:increment).with('data.load.device', source: 'mobile')
        Librato.should_receive(:increment).with('data.load.tech', source: 'html')
        Librato.should_receive(:increment).with('data.load.source', source: 'external')
        Librato.should_receive(:increment).with('data.load.embedded', source: 'true')
        icrementer.increment
      end
    end

    context "start (s) event" do
      let(:event_key) { 's' }
      before {
        data.stub(:device) { 'desktop' }
        data.stub(:tech) { 'flash' }
        data.stub(:source) { 'website' }
        data.stub(:em) { nil }
      }

      it "increments start stats" do
        Librato.should_receive(:increment).with('data.start.country', source: 'ch')
        Librato.should_receive(:increment).with('data.start.browser', source: 'saf')
        Librato.should_receive(:increment).with('data.start.platform', source: 'osx')
        Librato.should_receive(:increment).with('data.start.device', source: 'desktop')
        Librato.should_receive(:increment).with('data.start.tech', source: 'flash')
        Librato.should_receive(:increment).with('data.start.source', source: 'website')
        Librato.should_receive(:increment).with('data.start.embedded', source: 'false')
        icrementer.increment
      end
    end
  end
end
