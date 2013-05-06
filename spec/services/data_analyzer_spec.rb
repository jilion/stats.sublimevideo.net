require 'fast_spec_helper'

require 'data_analyzer'

describe DataAnalyzer do
  describe "#source_provenance" do
    specify { DataAnalyzer.new('ex' => 1).source_provenance.should eq 'e' }
    specify { DataAnalyzer.new('ex' => '1').source_provenance.should eq 'e' }
    specify { DataAnalyzer.new.source_provenance.should eq 'w' }
  end

  describe "#xyz" do
    specify { DataAnalyzer.new('x' => 1).x.should eq 1 }
    specify { DataAnalyzer.new('z' => 1).z.should eq 1 }
    specify { DataAnalyzer.new.z.should be_nil }
  end

  describe "#country_code" do
    it "uses GeoIPWrapper" do
      GeoIPWrapper.should_receive(:country).with('84.226.128.23') { 'ch' }
      DataAnalyzer.new('ip' => '84.226.128.23').country_code.should eq 'ch'
    end
  end

  describe "#browser_code" do
    it "uses UserAgentWrapper" do
      UserAgentWrapper.should_receive(:new).with('user agent') { mock('user_agent', browser_code: 'saf' ) }
      DataAnalyzer.new('ua' => 'user agent').browser_code.should eq 'saf'
    end
  end

  describe "#platform_code" do
    it "uses UserAgentWrapper" do
      UserAgentWrapper.should_receive(:new).with('user agent') { mock('user_agent', platform_code: 'osx' ) }
      DataAnalyzer.new('ua' => 'user agent').platform_code.should eq 'osx'
    end
  end
end
