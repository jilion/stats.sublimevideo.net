require 'spec_helper'

describe PlayWatcher do
  let(:site_token) { 'site_token' }
  let(:video_uid) { 'video_uid' }
  let(:watcher) { PlayWatcher.new(site_token, video_uid) }

  context "with video_uid params" do
    specify { expect(watcher.send(:_channel)).to eq('site_token:video_uid') }
  end

  context "without video_uid params" do
    let(:video_uid) { nil }
    specify { expect(watcher.send(:_channel)).to eq('site_token:*') }
  end
end
