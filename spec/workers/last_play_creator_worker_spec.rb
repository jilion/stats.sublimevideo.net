require 'fast_spec_helper'

require 'last_play_creator_worker'

describe LastPlayCreatorWorker do
  it "delays job in stats queue" do
    LastPlayCreatorWorker.sidekiq_options_hash['queue'].should eq 'stats'
  end

  describe ".perform" do
    let(:time) { Time.now.to_i }
    let(:data) { {
      's' => 'site_token',
      'u' => 'video_uid',
      't' => time,
      'ex' => 1,
      'du' => 'http://document.url/foo/bar',
      'ru' => 'http://referrer.url/foo/bar',
      'vsr' => '400x300',
      'ua' => 'USER AGENT',
      'ip' => '84.226.128.23'
    } }
    let(:redis) { double('Redis', publish: true) }
    before {
      Sidekiq.stub(:redis).and_yield(redis)
      DataHash.stub(:new) { data }
      data.stub(:country_code) { 'ch' }
      data.stub(:browser_code) { 'saf' }
      data.stub(:platform_code) { 'osx' }
    }

    it "creates last play with good params" do
      LastPlay.should_receive(:create).with(
        's' => 'site_token',
        'u' => 'video_uid',
        't' => time,
        'ex' => 1,
        'du' => 'http://document.url/foo/bar',
        'ru' => 'http://referrer.url/foo/bar',
        'co' => 'ch',
        'br' => 'saf',
        'pl' => 'osx')
      LastPlayCreatorWorker.new.perform(data)
    end

    it "publishes on redis channel" do
      expect(redis).to receive(:publish).with("site_token:video_uid", time)
      LastPlayCreatorWorker.new.perform(data)
    end
  end
end
