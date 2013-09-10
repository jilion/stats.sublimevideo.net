require 'spec_helper'

describe "LastPlays requests" do
  let(:redis) { double('Redis', psubscribe: true) }
  before { Sidekiq.stub(:redis).and_yield(redis) }

  describe "/plays" do
    context "without auth param" do
      it "renders 401" do
        get "plays"
        expect(response.status).to eq 401
      end
    end

    context "with bad auth param" do
      it "renders 401" do
        get "plays", auth: "foo"
        expect(response.status).to eq 401
      end
    end

    context "with wrong auth param" do
      it "renders 401" do
        get "plays", auth: "foo".encrypt(:symmetric)
        expect(response.status).to eq 401
      end
    end

    context "with good auth param" do
      let(:params) { { auth: "site1234:video_uid".encrypt(:symmetric) } }
      before { get "plays", params }

      it "assigns site_token and video_uid" do
        expect(assigns(:site_token)).to eq 'site1234'
        expect(assigns(:video_uid)).to eq 'video_uid'
      end

      it "renders 200" do
        expect(response.status).to eq 200
      end

      it "set good response headers" do
        expect(response.headers).to include(
          'Access-Control-Allow-Origin' => '*',
          'Content-Type'                => 'text/event-stream',
          'Cache-Control'               => 'no-cache'
        )
      end
    end
  end
end
