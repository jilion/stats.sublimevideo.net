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
end
