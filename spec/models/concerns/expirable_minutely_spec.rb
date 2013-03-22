require 'fast_spec_helper'
require 'config/mongoid'

require 'expirable_minutely'

describe ExpirableMinutely do
  class ExpirableMinutelyModel
    include Mongoid::Document
    include ExpirableMinutely
  end
  subject { ExpirableMinutelyModel }

  it { should have_index_for(c_at: 1).with_options(expireAfterSeconds: 62.seconds.to_i) }
end
