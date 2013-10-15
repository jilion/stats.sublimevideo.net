require 'spec_helper'

describe LastHoursFindable do
  class LastDaysStartsFindableModel
    include Mongoid::Document
    include Statsable
    include LastHoursFindable

    field :time, as: :t, type: Time
    field :key_id
  end
  let(:model_class) { LastDaysStartsFindableModel }

  describe ".last_hours_stats" do
    let(:args) { { key_id: 'key_id' } }

    context "with stats" do
      let(:today_previous_hour) { (Time.now.utc - 1.hour).change(min: 0) }
      before do
        48.times.each do |i|
          model_class.create(args.merge(
            time: today_previous_hour - i.hours,
            starts: { w: i, e: i }))
        end
      end

      it "returns last 2 hours of stats" do
        starts = model_class.last_hours_stats(args, 2).entries
        expect(starts).to eq [
          model_class.where(t: 1.hours.ago.utc.change(min: 0)).first,
          model_class.where(t: 2.hour.ago.utc.change(min: 0)).first
        ]
      end

      it "returns last 3 hours of stats" do
        starts = model_class.last_hours_stats(args, 3)
        expect(starts).to eq [
          model_class.where(t: 1.hours.ago.utc.change(min: 0)).first,
          model_class.where(t: 2.hours.ago.utc.change(min: 0)).first,
          model_class.where(t: 3.hour.ago.utc.change(min: 0)).first
        ]
      end
    end

    context "with unexistant stats" do
      it "returns 0 array" do
        starts = model_class.last_hours_stats(args, 4)
        expect(starts).to be_empty
      end
    end
  end

end
