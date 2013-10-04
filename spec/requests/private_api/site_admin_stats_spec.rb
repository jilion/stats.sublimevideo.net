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
      SiteAdminStat.create(
        site_token: site_token,
        time: 5.day.ago.utc.change(hour: 0),
        starts: { w: 1, e: 1 })
    }

    it "returns stats array with days" do
      get "private_api/site_admin_stats.json", { site_token: site_token, days: 4 }, @env
      body = MultiJson.load(response.body)

      expect(body).to have(1).stats
      expect(body[0]['st']).to eq({ 'w' => 1, 'e' => 1 })
    end

    it "returns stats array without days" do
      get "private_api/site_admin_stats.json", { site_token: site_token }, @env
      body = MultiJson.load(response.body)

      expect(body).to have(2).stats
    end
  end

  describe "last_days_starts" do
    before {
      SiteAdminStat.create(
        site_token: site_token,
        time: Time.now.utc.at_beginning_of_day - 1.hour,
        starts: { w: 1, e: 1 })
    }

    it "returns starts array" do
      get "private_api/site_admin_stats/last_days_starts.json", { site_token: site_token, days: 2 }, @env
      expect(MultiJson.load(response.body)).to eq [0, 2]
    end
  end

  describe "last_pages" do
    let(:url) { "private_api/site_admin_stats/last_pages.json" }
    before {
      SiteAdminStat.create(
        site_token: site_token,
        time: 1.day.ago.utc.change(hour: 0),
        pages: ['http://example.com'])
    }

    it_behaves_like 'valid caching headers', cache_control: 'max-age=3600, public', cache_validation: false

    it "returns pages array" do
      get url, { site_token: site_token }, @env
      body = MultiJson.load(response.body)

      expect(body).to eq ['http://example.com']
    end
  end

  describe "global_day_stat" do
    let(:day) { 1.days.ago.midnight.utc }
    let(:url) { "private_api/site_admin_stats/global_day_stat.json" }
    before {
      SiteAdminStat.create(site_token: '1', time: day, app_loads: { 'm' => 1 })
      SiteAdminStat.create(site_token: '2', time: day, app_loads: { 'm' => 1 })
    }

    it "returns global stat" do
      get url, { day: day.to_date }, @env
      body = MultiJson.load(response.body)

      expect(body).to eq({"al" => { "m" => 2 }, "lo" => {}, "st" => {} })
    end
  end

  describe "last_30_days_sites_with_starts" do
    let(:day) { 1.days.ago }
    let(:url) { "private_api/site_admin_stats/last_30_days_sites_with_starts.json" }
    before {
      SiteAdminStat.create(site_token: '1', time: 1.days.ago, starts: { 'w' => 1 })
      SiteAdminStat.create(site_token: '2', time: 5.days.ago, starts: { 'e' => 1 })
    }

    it "returns global stat" do
      get url, { day: day.to_date, threshold: 1 }, @env
      body = MultiJson.load(response.body)

      expect(body).to eq 2
    end
  end

end
