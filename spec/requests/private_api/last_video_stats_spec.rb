require 'spec_helper'

describe "LastSiteStats private api requests" do
  let(:site_token) { 'site_token' }
  let(:video_uid) { 'video_uid' }
  before { set_api_credentials }

  describe "index" do
    before {
      LastVideoStat.create(
        site_token: site_token,
        video_uid: video_uid,
        time: 1.minute.ago,
        starts: 1,
        loads: 2)
    }

    it "returns stats array" do
      get "private_api/last_video_stats.json", { site_token: site_token, video_uid: video_uid }, @env
      body = MultiJson.load(response.body)

      expect(body[0]['st']).to eq(1)
      expect(body[0]['lo']).to eq(2)
    end
  end

end
