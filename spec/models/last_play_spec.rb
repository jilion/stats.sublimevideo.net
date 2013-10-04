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
      @latest_stat1 = described_class.create(time: 1.minute.ago)
      @latest_stat2 = described_class.create(time: 2.minutes.ago)
      described_class.create(time: 61.minutes.ago)
    end

    it 'returns the right records with a Time object' do
      expect(described_class.since(3.minutes.ago).entries).to eq [@latest_stat1, @latest_stat2]
    end

    it 'returns the right records with an Integer' do
      expect(described_class.since(3.minutes.ago.to_i).entries).to eq [@latest_stat1, @latest_stat2]
    end

    it 'returns the right records with a String' do
      expect(described_class.since(3.minutes.ago.to_i.to_s).entries).to eq [@latest_stat1, @latest_stat2]
    end

    it 'returns the right records with nil' do
      expect(described_class.since(nil).entries).to eq [@latest_stat1, @latest_stat2]
    end
  end
end
