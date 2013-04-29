require 'spec_helper'

describe IncrementableStat do
  class IncrementableStatModel
    include Mongoid::Document
    include IncrementableStat
    field :key_id
    field :time, as: :t, type: Time
    field :foos, as: :f, type: Integer

    def self.time_precision
      { hours: 0 }
    end
  end
  subject { IncrementableStatModel }

  describe ".inc_stat" do
    let(:key_id) { 'key_id' }
    let(:time) { Time.now.to_i }
    let(:args) { { key_id: key_id, time: time } }

    it "creates stat if not present" do
      IncrementableStatModel.inc_stat(args, :foos)
      stat = IncrementableStatModel.last
      stat.key_id.should eq key_id
      stat.time.should eq Time.at(time).change(hours: 0)
      stat.foos.should eq 1
    end

    it "increments stat if present" do
      IncrementableStatModel.inc_stat(args, :foos)
      IncrementableStatModel.inc_stat(args, :foos)
      IncrementableStatModel.count.should eq 1
      IncrementableStatModel.last.foos.should eq 2
    end
  end
end
