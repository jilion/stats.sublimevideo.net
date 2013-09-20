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
        data.stub(:stats_addon?) { '1' }
        data.stub(:stage) { 'stable' }
        data.stub(:fv) { '1.0.0' }
        data.stub(:jq) { '2.0.0' }
        data.stub(:sr) { '2400x1920' }
        data.stub(:sd) { '180' }
        data.stub(:bl) { 'ch-fr' }
      }


      it "increments app load stats" do
        expect(Librato).to receive(:increment).with('data.app_load.country', source: 'ch')
        expect(Librato).to receive(:increment).with('data.app_load.browser', source: 'saf')
        expect(Librato).to receive(:increment).with('data.app_load.platform', source: 'osx')
        expect(Librato).to receive(:increment).with('data.app_load.hostname', source: 'main')
        expect(Librato).to receive(:increment).with('data.app_load.ssl', source: 'on')
        expect(Librato).to receive(:increment).with('data.app_load.stats_addon', source: 'on')
        expect(Librato).to receive(:increment).with('data.app_load.stage', source: 'stable')
        expect(Librato).to receive(:increment).with('data.app_load.flash_version', source: '1.0.0')
        expect(Librato).to receive(:increment).with('data.app_load.jquery_version', source: '2.0.0')
        expect(Librato).to receive(:increment).with('data.app_load.screen_resolution', source: '2400x1920')
        expect(Librato).to receive(:increment).with('data.app_load.screen_dpr', source: '180')
        expect(Librato).to receive(:increment).with('data.app_load.browser_language', source: 'ch-fr')
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
        expect(Librato).to receive(:increment).with('data.load.country', source: 'ch')
        expect(Librato).to receive(:increment).with('data.load.browser', source: 'saf')
        expect(Librato).to receive(:increment).with('data.load.platform', source: 'osx')
        expect(Librato).to receive(:increment).with('data.load.device', source: 'mobile')
        expect(Librato).to receive(:increment).with('data.load.tech', source: 'html')
        expect(Librato).to receive(:increment).with('data.load.source', source: 'external')
        expect(Librato).to receive(:increment).with('data.load.embedded', source: 'true')
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
        expect(Librato).to receive(:increment).with('data.start.country', source: 'ch')
        expect(Librato).to receive(:increment).with('data.start.browser', source: 'saf')
        expect(Librato).to receive(:increment).with('data.start.platform', source: 'osx')
        expect(Librato).to receive(:increment).with('data.start.device', source: 'desktop')
        expect(Librato).to receive(:increment).with('data.start.tech', source: 'flash')
        expect(Librato).to receive(:increment).with('data.start.source', source: 'website')
        expect(Librato).to receive(:increment).with('data.start.embedded', source: 'false')
        icrementer.increment
      end
    end
  end
end
