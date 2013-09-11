require 'fast_spec_helper'
require 'config/redis'
require 'config/sidekiq'

require 'pusher_wrapper'

describe PusherWrapper, :redis do
  let(:channel) { 'channel' }
  let(:wrapper) { PusherWrapper.new(channel) }

  describe "#trigger" do
    context "with occupied channel" do
      before { $redis.sadd('pusher:channels', channel) }

      it "triggers Pusher" do
        expect(Pusher).to receive(:trigger).with(channel, 'event', foo: 'bar')
        wrapper.trigger('event', foo: 'bar')
      end
    end

    context "with unoccupied channel" do
      it "doesn't trigger Pusher" do
        expect(Pusher).to_not receive(:trigger)
        wrapper.trigger('event', foo: 'bar')
      end
    end
  end

end
