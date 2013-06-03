require 'fast_spec_helper'
require 'config/mongoid'

require 'hourly_expirable'

describe HourlyExpirable do
  class HourlyExpirableModel
    include Mongoid::Document
    include HourlyExpirable
    field :time, as: :t, type: Time
  end
  subject { HourlyExpirableModel }

  # https://github.com/evansagge/mongoid-rspec/issues/102
  # it { should have_index_for(t: 1).with_options(expireAfterSeconds: 61.minutes.to_i) }
end
