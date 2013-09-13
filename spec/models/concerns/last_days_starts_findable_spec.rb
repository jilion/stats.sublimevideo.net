require 'spec_helper'

describe LastDaysStartsFindable do
  class LastDaysStartsFindableModel
    include Mongoid::Document
    include Statsable
    include LastDaysStartsFindable

    field :time, as: :t, type: Time
    field :key_id
  end
  let(:model_class) { LastDaysStartsFindableModel }

  describe ".last_days_starts" do
    let(:args) { { key_id: 'key_id' } }

    context "with stats" do
      let(:yesterday_last_hour_of_day) { Time.now.utc.at_beginning_of_day - 1.hour }
      before {
        4.times.each do |i|
          next if i%2 == 0
          model_class.create(args.merge(
            time: yesterday_last_hour_of_day - i.days,
            starts: { w: i, e: i }))
        end
      }

      it "returns last 4 days of starts" do
        starts = model_class.last_days_starts(args, 4)
        starts.should eq [6, 0, 2, 0]
      end

      it "returns last 2 days of starts" do
        starts = model_class.last_days_starts(args, 2)
        starts.should eq [2, 0]
      end
    end

    context "with unexistant stats" do
      it "returns 0 array" do
        starts = model_class.last_days_starts(args, 4)
        starts.should eq [0, 0, 0, 0]
      end
    end
  end

  describe "#starts_sum" do
    subject { model_class.new(starts: { w: 2, e: 3 }) }

    its(:starts_sum) { should eq 5 }
  end
end
