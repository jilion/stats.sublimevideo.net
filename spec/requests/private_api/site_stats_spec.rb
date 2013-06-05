require 'spec_helper'

describe "SiteStats private api requests" do
  let(:site_token) { 'site_token' }
  before { set_api_credentials }

  describe "last_days_starts" do
    before {
      SiteStat.create(
        site_token: site_token,
        time: Time.now.utc.at_beginning_of_day - 1.hour,
        starts: { w: 1, e: 1 })
    }

    it "returns starts array" do
      get "private_api/site_stats/#{site_token}/last_days_starts.json", { days: 2 }, @env
      MultiJson.load(response.body).should eq({"starts" => [0, 2]})
    end
  end
end
