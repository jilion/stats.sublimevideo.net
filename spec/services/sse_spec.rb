require 'fast_spec_helper'

require 'sse'

describe SSE do
  let(:io) { double("IO") }
  let(:sse) { SSE.new(io) }

  describe "#initalize" do

    it "keeps connection open by writing heartbreak" do
      expect(io).to receive(:write).with("event: heartbeat\n")
      sse
      sleep 0.01 # wait for heartbreak thread
    end
  end

  describe "#write" do
    context "with no options" do
      it "writes data in json to io" do
        expect(io).to receive(:write).with("data: {\"foo\":\"bar\"}\n\n")
        sse.write(foo: 'bar')
      end
    end
    context "with options" do
      it "writes data in json to io preceded with options" do
        expect(io).to receive(:write).with("event: foo\n")
        expect(io).to receive(:write).with("data: {\"foo\":\"bar\"}\n\n")
        sse.write({ foo: 'bar' }, event: 'foo')
      end
    end
  end

  describe "#close" do
    it "closes io" do
      expect(io).to receive(:close)
      sse.close
    end
  end

end
