require 'spec_helper'

describe "LastPlays requests" do
  let(:redis) { double('Redis', psubscribe: true) }
  before { Sidekiq.stub(:redis).and_yield(redis) }

  describe "/plays" do
    it "set good response headers" do
      get "plays"
      expect(response.headers).to include(
        'Access-Control-Allow-Origin' => '*',
        'Content-Type'                => 'text/event-stream',
        'Cache-Control'               => 'no-cache'
      )
    end
  end
end
