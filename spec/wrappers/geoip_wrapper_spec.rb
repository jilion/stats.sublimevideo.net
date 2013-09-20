require 'fast_spec_helper'

require 'geoip_wrapper'

describe GeoIPWrapper do

  describe ".country" do
    it "returns country code for Switzerland IPV4 address" do
      expect(GeoIPWrapper.country('84.226.128.23')).to eq 'ch'
    end

    it "returns country code United Kingdom IPV4 address" do
      expect(GeoIPWrapper.country('46.231.14.49')).to eq 'gb'
    end

    it "returns country code China IPV4 address" do
      expect(GeoIPWrapper.country('125.69.132.100')).to eq 'cn'
    end

    it "returns country code US IPV4 address" do
      expect(GeoIPWrapper.country('192.110.163.22')).to eq 'us'
    end

    it "returns country code Russian IPV4 address" do
      expect(GeoIPWrapper.country('81.25.51.176')).to eq 'ru'
    end

    it "returns -- for 127.0.0.1" do
      expect(GeoIPWrapper.country('127.0.0.1')).to eq '--'
    end

    it "returns -- for localhost" do
      expect(GeoIPWrapper.country('localhost')).to eq '--'
    end

    it "returns -- for non ip" do
      expect(GeoIPWrapper.country('')).to eq '--'
    end

    it "returns -- when raise" do
      GeoIP.stub(:new).and_raise('error')
      expect(GeoIPWrapper.country('81.25.51.176')).to eq '--'
    end
  end

end
