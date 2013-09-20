require 'spec_helper'

describe "SiteAdminStats private api requests" do
  let(:site_token) { 'site_token' }
  before { set_api_credentials }

  describe "index" do
    before {
      SiteAdminStat.create(
        site_token: site_token,
        time: 1.day.ago.utc.change(hour: 0),
        starts: { w: 1, e: 1 })
    }

    it "returns stats array" do
      get "private_api/sites/#{site_token}/site_admin_stats.json", { days: 4 }, @env
      body = MultiJson.load(response.body)['stats']

      expect(body[0]['st']).to eq({ 'w' => 1, 'e' => 1 })
    end
  end
end
