require 'spec_helper'

describe "SiteStats private api requests" do
  let(:site_token) { 'site_token' }
  before { set_api_credentials }

  describe "index" do
    before {
      SiteStat.create(
        site_token: site_token,
        time: 1.hour.ago,
        starts: { w: 1, e: 1 },
        countries: { w:  { us: 12, fr: 42 }, e: { us: 13, fr: 43 } })
    }

    it "returns stats array" do
      get "private_api/sites/#{site_token}/site_stats.json", { hours: 24 }, @env
      body = MultiJson.load(response.body)['stats']

      body[0]['st'].should eq({ 'w' => 1, 'e' => 1 })
      body[0]['co'].should eq({ 'w' => { 'us' => 12, 'fr' => 42 }, 'e' => { 'us' => 13, 'fr' => 43 } })
    end
  end

  describe "last_days_starts" do
    before {
      SiteStat.create(
        site_token: site_token,
        time: Time.now.utc.at_beginning_of_day - 1.hour,
        starts: { w: 1, e: 1 })
    }

    it "returns starts array" do
      get "private_api/sites/#{site_token}/site_stats/last_days_starts.json", { days: 2 }, @env
      MultiJson.load(response.body).should eq({"starts" => [0, 2]})
    end
  end
end
