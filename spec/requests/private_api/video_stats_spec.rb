require 'spec_helper'

describe "VideoStats private api requests" do
  let(:site_token) { 'site_token' }
  let(:video_uid) { 'video_uid' }
  before { set_api_credentials }

  describe "last_days_starts" do
    before {
      VideoStat.create(
        site_token: site_token, video_uid: video_uid,
        time: Time.now.utc.at_beginning_of_day - 1.hour,
        starts: { w: 1, e: 1 })
    }

    it "returns starts array" do
      get "private_api/sites/#{site_token}/video_stats/#{video_uid}/last_days_starts.json", { days: 2 }, @env
      MultiJson.load(response.body).should eq({"starts" => [0, 2]})
    end
  end
end
