require 'spec_helper'

describe LastPlay do
  it { should be_kind_of Mongoid::Document }
  it { should be_kind_of Mongoid::Timestamps::Created::Short }

  it { should have_index_for(s: 1, c_at: -1) }
  it { should have_index_for(s: 1, u: 1, c_at: -1) }
  it { should have_index_for(c_at: 1).with_options(expireAfterSeconds: 61.minutes.to_i) }
end
