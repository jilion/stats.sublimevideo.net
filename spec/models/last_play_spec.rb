require 'spec_helper'

describe LastPlay do
  it { should be_kind_of Mongoid::Document }
  it { should be_kind_of VideoIdentifiable }
  it { should be_kind_of HourlyExpirable }

  # https://github.com/evansagge/mongoid-rspec/issues/102
  # it { should have_index_for(s: 1, t: -1) }

  it "casts Boolean for external field" do
    expect(LastPlay.new(external: '0').external).to be_false
    expect(LastPlay.new(external:  0).external).to be_false
    expect(LastPlay.new(external: '1').external).to be_true
    expect(LastPlay.new(external: 1).external).to be_true
  end

  describe '.since' do
    before do
      @latest_stat = described_class.create(time: 1.days.ago)
      described_class.create(time: 2.days.ago)
      described_class.create(time: 31.days.ago)
    end

    it 'returns the right records' do
      expect(described_class.since(2.days.ago).entries).to eq [@latest_stat]
    end
  end
end
