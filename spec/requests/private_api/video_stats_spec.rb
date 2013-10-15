require 'spec_helper'

describe "VideoStats private api requests" do
  let(:site_token) { 'site_token' }
  let(:video_uid) { 'video_uid' }
  before { set_api_credentials }

  describe "index" do
    before do
      VideoStat.create(
        site_token: site_token, video_uid: video_uid,
        time: 2.hours.ago,
        starts: { w: 1, e: 1 },
        countries: { w:  { us: 12, fr: 42 }, e: { us: 13, fr: 43 } })
      VideoStat.create(
        site_token: site_token, video_uid: video_uid,
        time: 1.hour.ago,
        starts: { w: 2, e: 2 },
        countries: { w:  { us: 12, fr: 42 }, e: { us: 13, fr: 43 } })
    end

    let(:url) { "private_api/video_stats.json" }

    it "returns stats array" do
      get url, { site_token: site_token, video_uid: video_uid, hours: 24 }, @env
      body = MultiJson.load(response.body)

      expect(body[0]['st']).to eq({ 'w' => 2, 'e' => 2 })
      expect(body[0]['co']).to eq({ 'w' => { 'us' => 12, 'fr' => 42 }, 'e' => { 'us' => 13, 'fr' => 43 } })

      expect(body[1]['st']).to eq({ 'w' => 1, 'e' => 1 })
      expect(body[1]['co']).to eq({ 'w' => { 'us' => 12, 'fr' => 42 }, 'e' => { 'us' => 13, 'fr' => 43 } })
    end
  end

  describe "last_days_starts" do
    before {
      VideoStat.create(
        site_token: site_token, video_uid: video_uid,
        time: Time.now.utc.at_beginning_of_day - 1.hour,
        starts: { w: 1, e: 1 })
    }

    it "returns starts array" do
      get "private_api/video_stats/last_days_starts.json", { site_token: site_token, video_uid: video_uid, days: 2 }, @env
      expect(MultiJson.load(response.body)).to eq [0, 2]
    end
  end

end
