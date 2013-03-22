require 'fast_spec_helper'
require 'config/mongoid'

require 'expirable_hourly'

describe ExpirableHourly do
  class ExpirableHourlyModel
    include Mongoid::Document
    include ExpirableHourly
  end
  subject { ExpirableHourlyModel }

  it { should have_index_for(c_at: 1).with_options(expireAfterSeconds: 62.minutes.to_i) }
end
