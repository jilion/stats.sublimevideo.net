require 'spec_helper'

describe "LastSiteStats private api requests" do
  let(:site_token) { 'site_token' }
  before { set_api_credentials }

  describe "index" do
    before {
      LastSiteStat.create(
        site_token: site_token,
        time: 1.minute.ago,
        starts: 1,
        loads: 2)
    }

    it "returns stats array" do
      get "private_api/sites/#{site_token}/last_site_stats.json", { }, @env
      body = MultiJson.load(response.body)['stats']

      expect(body[0]['st']).to eq(1)
      expect(body[0]['lo']).to eq(2)
    end

    it "sets last_modified from since params if present" do
      time = Time.now.utc
      get "private_api/sites/#{site_token}/last_site_stats.json", { since: time.to_i }, @env

      expect(response.headers['Last-Modified']).to eq time.strftime("%a, %d %b %Y %H:%M:%S GMT")
    end
  end

end
