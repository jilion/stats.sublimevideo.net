require 'fast_spec_helper'

require 'data_hash'
require 'last_play_creator'

describe LastPlayCreator do

  describe "#create" do
    let(:time) { Time.now.to_i }
    let(:data) { DataHash.new(
      's' => 'site_token',
      'u' => 'video_uid',
      't' => time,
      'ex' => 1,
      'du' => 'http://document.url/foo/bar',
      'ru' => 'http://referrer.url/foo/bar',
      'vsr' => '400x300',
      'ua' => 'USER AGENT',
      'ip' => '84.226.128.23'
    ) }
    let(:pusher_wrapper) { double(PusherWrapper, trigger: true)}
    before {
      PusherWrapper.stub(:new) { pusher_wrapper }
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
      LastPlayCreator.create(data)
    end

    it "triggers Pusher play event on site channel" do
      expect(PusherWrapper).to receive(:new).with('private-site_token') { pusher_wrapper }
      expect(pusher_wrapper).to receive(:trigger).with('play', time)
      LastPlayCreator.create(data)
    end

    it "triggers Pusher play event on video channel" do
      expect(PusherWrapper).to receive(:new).with('private-site_token.video_uid') { pusher_wrapper }
      expect(pusher_wrapper).to receive(:trigger).with('play', time)
      LastPlayCreator.create(data)
    end
  end
end
