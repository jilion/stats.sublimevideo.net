require 'spec_helper'

describe "LastPlays private api requests" do
  let(:site_token) { 'site_token' }
  let(:video_uid) { 'video_uid' }
  before { set_api_credentials }

  describe "index" do
    before {
      3.times do |i|
        LastPlay.create(
          site_token: site_token,
          video_uid: video_uid,
          time: i.minutes.ago)
        LastPlay.create(
          site_token: site_token,
          video_uid: 'video_uid2',
          time: i.minutes.ago)
      end
    }

    it "sets cache header" do
      get "private_api/sites/#{site_token}/last_plays.json", {}, @env
      expect(response.headers.keys).to include("ETag", "Last-Modified")
    end

    context "sites last_plays" do
      it "returns 3 last_plays" do
        get "private_api/sites/#{site_token}/last_plays.json", {}, @env
        expect(MultiJson.load(response.body)['plays']).to have(3).plays
      end
    end

    context "videos last_plays" do
      it "returns 3 last_plays" do
        get "private_api/sites/#{site_token}/videos/#{video_uid}/last_plays.json", {}, @env
        expect(MultiJson.load(response.body)['plays']).to have(3).plays
      end
    end
  end
end
