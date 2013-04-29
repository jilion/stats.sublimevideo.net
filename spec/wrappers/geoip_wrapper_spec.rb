require 'fast_spec_helper'

require 'geoip_wrapper'

describe GeoIPWrapper do

  describe ".country" do
    it "returns country code for Switzerland IPV4 address" do
      GeoIPWrapper.country('84.226.128.23').should eq 'ch'
    end

    it "returns country code United Kingdom IPV4 address" do
      GeoIPWrapper.country('46.231.14.49').should eq 'uk'
    end

    it "returns country code China IPV4 address" do
      GeoIPWrapper.country('125.69.132.100').should eq 'cn'
    end

    it "returns country code US IPV4 address" do
      GeoIPWrapper.country('192.110.163.22').should eq 'us'
    end

    it "returns country code Russian IPV4 address" do
      GeoIPWrapper.country('81.25.51.176').should eq 'ru'
    end

    it "returns nil for 127.0.0.1" do
      GeoIPWrapper.country('127.0.0.1').should be_nil
    end

    it "returns nil for localhost" do
      GeoIPWrapper.country('localhost').should be_nil
    end

    it "returns nil for non ip" do
      GeoIPWrapper.country('I am not an IP').should be_nil
    end
  end

end
