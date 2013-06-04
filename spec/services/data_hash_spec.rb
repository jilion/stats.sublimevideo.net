require 'fast_spec_helper'

require 'data_hash'

describe DataHash do
  describe "#source_key" do
    specify { DataHash.new('ex' => 1).source_key.should eq 'e' }
    specify { DataHash.new('ex' => '1').source_key.should eq 'e' }
    specify { DataHash.new.source_key.should eq 'w' }
  end

  describe "#source" do
    specify { DataHash.new('ex' => 1).source.should eq 'external' }
    specify { DataHash.new.source.should eq 'website' }
  end

  describe "#xyz" do
    specify { DataHash.new('x' => 1).x.should eq 1 }
    specify { DataHash.new('z' => 1).z.should eq 1 }
    specify { DataHash.new.z.should be_nil }
  end

  describe "#country_code" do
    it "uses GeoIPWrapper" do
      GeoIPWrapper.should_receive(:country).with('84.226.128.23') { 'ch' }
      DataHash.new('ip' => '84.226.128.23').country_code.should eq 'ch'
    end
  end

  describe "#browser_code" do
    it "uses UserAgentWrapper" do
      UserAgentWrapper.should_receive(:new).with('user agent') { mock('user_agent', browser_code: 'saf' ) }
      DataHash.new('ua' => 'user agent').browser_code.should eq 'saf'
    end
  end

  describe "#platform_code" do
    it "uses UserAgentWrapper" do
      UserAgentWrapper.should_receive(:new).with('user agent') { mock('user_agent', platform_code: 'osx' ) }
      DataHash.new('ua' => 'user agent').platform_code.should eq 'osx'
    end
  end

  describe "#hostname" do
    specify { DataHash.new('ho' => 'm').hostname.should eq 'main' }
    specify { DataHash.new('ho' => 'e').hostname.should eq 'extra' }
    specify { DataHash.new('ho' => 's').hostname.should eq 'staging' }
    specify { DataHash.new('ho' => 'd').hostname.should eq 'dev' }
    specify { DataHash.new('ho' => 'i').hostname.should eq 'invalid' }
  end

  describe "#stage" do
    specify { DataHash.new('st' => 'a').stage.should eq 'alpha' }
    specify { DataHash.new('st' => 'b').stage.should eq 'beta' }
    specify { DataHash.new('st' => 's').stage.should eq 'stable' }
  end

  describe "#device" do
    specify { DataHash.new('de' => 'd').device.should eq 'desktop' }
    specify { DataHash.new('de' => 'm').device.should eq 'mobile' }
  end

  describe "#tech" do
    specify { DataHash.new('te' => 'h').tech.should eq 'html' }
    specify { DataHash.new('te' => 'f').tech.should eq 'flash' }
    specify { DataHash.new('te' => 'y').tech.should eq 'youtube' }
    specify { DataHash.new('te' => 'd').tech.should eq 'dailymotion' }
  end
end
