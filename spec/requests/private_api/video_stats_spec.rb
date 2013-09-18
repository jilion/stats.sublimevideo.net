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

    let(:url) { "private_api/sites/#{site_token}/videos/#{video_uid}/video_stats.json" }

    it "returns stats array" do
      get url, { hours: 24 }, @env
      body = MultiJson.load(response.body)['stats']

      body[0]['st'].should eq({ 'w' => 1, 'e' => 1 })
      body[0]['co'].should eq({ 'w' => { 'us' => 12, 'fr' => 42 }, 'e' => { 'us' => 13, 'fr' => 43 } })

      body[1]['st'].should eq({ 'w' => 2, 'e' => 2 })
      body[1]['co'].should eq({ 'w' => { 'us' => 12, 'fr' => 42 }, 'e' => { 'us' => 13, 'fr' => 43 } })
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
      get "private_api/sites/#{site_token}/videos/#{video_uid}/video_stats/last_days_starts.json", { days: 2 }, @env
      MultiJson.load(response.body).should eq({"starts" => [0, 2]})
    end
  end

end
