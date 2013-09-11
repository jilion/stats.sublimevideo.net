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
    let(:pusher_wrapper) { double(PusherWrapper, trigger: true)}
    before {
      PusherWrapper.stub(:new) { pusher_wrapper }
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

    it "triggers Pusher play event on site channel" do
      expect(PusherWrapper).to receive(:new).with('private-site_token') { pusher_wrapper }
      expect(pusher_wrapper).to receive(:trigger).with('play', time)
      LastPlayCreatorWorker.new.perform(data)
    end

    it "triggers Pusher play event on video channel" do
      expect(PusherWrapper).to receive(:new).with('private-site_token.video_uid') { pusher_wrapper }
      expect(pusher_wrapper).to receive(:trigger).with('play', time)
      LastPlayCreatorWorker.new.perform(data)
    end
  end
end
