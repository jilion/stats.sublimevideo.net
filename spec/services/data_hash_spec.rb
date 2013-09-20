require 'fast_spec_helper'

require 'data_hash'

describe DataHash do
  describe "#source_key" do
    specify { expect(DataHash.new('ex' => 1).source_key).to eq 'e' }
    specify { expect(DataHash.new('ex' => '1').source_key).to eq 'e' }
    specify { expect(DataHash.new.source_key).to eq 'w' }
  end

  describe "#source" do
    specify { expect(DataHash.new('ex' => 1).source).to eq 'external' }
    specify { expect(DataHash.new.source).to eq 'website' }
  end

  describe "#xyz" do
    specify { expect(DataHash.new('x' => 1).x).to eq 1 }
    specify { expect(DataHash.new('z' => 1).z).to eq 1 }
    specify { expect(DataHash.new.z).to be_nil }
  end

  describe "#stats_addon?" do
    specify { expect(DataHash.new().stats_addon?).to be_false }
    specify { expect(DataHash.new('sa' => '1').stats_addon?).to be_true }
    specify { expect(DataHash.new('sa' => 1).stats_addon?).to be_true }
  end

  describe "#country_code" do
    it "uses GeoIPWrapper" do
      expect(GeoIPWrapper).to receive(:country).with('84.226.128.23') { 'ch' }
      expect(DataHash.new('ip' => '84.226.128.23').country_code).to eq 'ch'
    end
  end

  describe "#browser_code" do
    it "uses UserAgentWrapper" do
      expect(UserAgentWrapper).to receive(:new).with('user agent') { double('user_agent', browser_code: 'saf' ) }
      expect(DataHash.new('ua' => 'user agent').browser_code).to eq 'saf'
    end
  end

  describe "#platform_code" do
    it "uses UserAgentWrapper" do
      expect(UserAgentWrapper).to receive(:new).with('user agent') { double('user_agent', platform_code: 'osx' ) }
      expect(DataHash.new('ua' => 'user agent').platform_code).to eq 'osx'
    end
  end

  describe "#hostname" do
    specify { expect(DataHash.new('ho' => 'm').hostname).to eq 'main' }
    specify { expect(DataHash.new('ho' => 'e').hostname).to eq 'extra' }
    specify { expect(DataHash.new('ho' => 's').hostname).to eq 'staging' }
    specify { expect(DataHash.new('ho' => 'd').hostname).to eq 'dev' }
    specify { expect(DataHash.new('ho' => 'i').hostname).to eq 'invalid' }
  end

  describe "#stage" do
    specify { expect(DataHash.new('st' => 'a').stage).to eq 'alpha' }
    specify { expect(DataHash.new('st' => 'b').stage).to eq 'beta' }
    specify { expect(DataHash.new('st' => 's').stage).to eq 'stable' }
  end

  describe "#device" do
    specify { expect(DataHash.new('de' => 'd').device).to eq 'desktop' }
    specify { expect(DataHash.new('de' => 'm').device).to eq 'mobile' }
  end

  describe "#tech" do
    specify { expect(DataHash.new('te' => 'h').tech).to eq 'html' }
    specify { expect(DataHash.new('te' => 'f').tech).to eq 'flash' }
    specify { expect(DataHash.new('te' => 'y').tech).to eq 'youtube' }
    specify { expect(DataHash.new('te' => 'd').tech).to eq 'dailymotion' }
  end
end
