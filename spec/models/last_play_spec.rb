require 'spec_helper'

describe LastPlay do
  it { should be_kind_of Mongoid::Document }
  it { should be_kind_of VideoIdentifiable }
  it { should be_kind_of HourlyExpirable }

  it { should have_index_for(s: 1, t: -1) }

  it "casts Boolean for external field" do
    LastPlay.new(external: '0').external.should be_false
    LastPlay.new(external:  0).external.should be_false
    LastPlay.new(external: '1').external.should be_true
    LastPlay.new(external: 1).external.should be_true
  end
end
