require 'fast_spec_helper'
require 'config/mongoid'

require 'expirable_daily'

describe ExpirableDaily do
  class ExpirableDailyModel
    include Mongoid::Document
    include ExpirableDaily
  end
  subject { ExpirableDailyModel }

  it { should have_index_for(c_at: 1).with_options(expireAfterSeconds: 27.hours.to_i) }
end
