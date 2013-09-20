require 'spec_helper'

describe LastStatsable do
  class LastStatsableModel
    include Mongoid::Document
    include LastStatsable

    field :t, as: :time, type: Time
    field :key_id
  end
  subject { LastStatsableModel }

  it { should have_field(:lo).with_alias(:loads).of_type(Integer) }
  it { should have_field(:st).with_alias(:starts).of_type(Integer) }

  describe ".upsert_stat" do
    let(:key_id) { 'key_id' }
    let(:time) { Time.now.to_i }
    let(:args) { { 'key_id' => key_id, 't' => time.to_s } }

    it "creates stat if not present" do
      LastStatsableModel.upsert_stat(args, :loads)
      stat = LastStatsableModel.last
      expect(stat.key_id).to eq key_id
      expect(stat.time).to eq Time.at(time).utc.change(sec: 0)
      expect(stat.loads).to eq 1
    end

    it "increments stat if present" do
      LastStatsableModel.upsert_stat(args, :loads)
      LastStatsableModel.upsert_stat(args, :loads)
      expect(LastStatsableModel.count).to eq 1
      expect(LastStatsableModel.last.loads).to eq 2
    end
  end

end
