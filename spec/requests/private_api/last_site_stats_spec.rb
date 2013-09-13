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

      body[0]['st'].should eq(1)
      body[0]['lo'].should eq(2)
    end
  end

end
